# Part 1 — JMESPath Fundamentals via kyverno jp query

> Prerequisite: [Landing page](./course.md). Next: [Part 2 — Kyverno's Custom JMESPath Functions](./course-02-kyvernos-custom-jmespath-functions.md).

## What JMESPath actually is

JMESPath is a query language for JSON, the same family of idea as `jq` or XPath-for-XML. You give it a document and an expression, and it returns the part of the document (or a computed value) the expression describes. Kyverno chose it as the expression language for `context.apiCall`, variable substitution (`{{ }}`), `preconditions`, and `foreach` — anywhere a policy needs to reach into a resource and pull out or test a value.

Because it's a real, general-purpose query language and not a Kyverno-only invention, everything you learn here also applies the moment you read a `match`/`preconditions` block in any Kyverno policy.

## `kyverno jp query` — the real interface

```
kyverno jp query [-i input] [-q query|query]... [flags]
```

| Flag | Meaning |
| --- | --- |
| `-i, --input string` | Read the input document from a JSON or YAML file instead of stdin |
| `-q, --query strings` | Read the JMESPath expression from a file (repeatable — chain multiple expressions) |
| `-c, --compact` | Compact JSON output, no extra whitespace |
| `-u, --unquoted` | If the final result is a string, print it without the surrounding `"quotes"` |
| `-h, --help` | Help for this command |

By default, a string result is printed **JSON-quoted** (`"checkout"`), which is exactly right when you're piping the output into something else that expects JSON, but almost never what you want to eyeball in a terminal or capture into a plain-text file — that's what `-u` is for.

```sh
kyverno jp query -i object.yaml 'request.object.metadata.name | truncate(@, `9`)'
```

You can also pipe a query in from a file, or pipe the input document in from stdin instead of `-i` — all four combinations (file/file, file/stdin, stdin/file, stdin/stdin) work:

```sh
kyverno jp query -i object.yaml -q query-file
cat query-file | kyverno jp query -i object.yaml
cat object.yaml | kyverno jp query -q query-file
```

## Core JMESPath syntax

Given this document:

```json
{
  "metadata": { "name": "checkout-web-7f8c9", "labels": { "team": "checkout" } },
  "spec": {
    "containers": [
      { "name": "web", "image": "registry.example.com/checkout/web:1.4.2" },
      { "name": "sidecar", "image": "registry.example.com/checkout/envoy:1.28.0" }
    ]
  }
}
```

| Expression | Result | What it does |
| --- | --- | --- |
| `metadata.name` | `"checkout-web-7f8c9"` | Dot notation walks nested object keys |
| `spec.containers[0].image` | `"registry.example.com/checkout/web:1.4.2"` | `[N]` indexes into an array |
| `spec.containers[*].name` | `["web", "sidecar"]` | `[*]` projects — applies the rest of the expression to every element |
| `spec.containers[?name=='web'].image` | `["registry.example.com/checkout/web:1.4.2"]` | `[?...]` is a filter expression |
| `metadata.name \| length(@)` | `19` | `\|` pipes a result into the next expression, `@` refers to the current value |

> [!TIP]
> **Try it — projections vs indexing**
>
> ```sh
> kyverno jp query -i pod.json -u 'spec.containers[*].name'
> kyverno jp query -i pod.json -u 'spec.containers[0].name'
> ```
>
> The first returns every container's name as a list; the second returns just one. Confusing the two — expecting a single value back from a projection — is one of the most common reasons a Kyverno variable ends up bound to an unexpected array instead of a scalar.

## Literals: raw strings vs JSON literals

JMESPath expressions have two distinct ways to write a literal value, and mixing them up is a frequent source of "why does this always evaluate to `null`" bugs:

- **Raw string literal** — single quotes, exactly what you want for comparing against a string field: `` name=='checkout' ``, `` pattern_match('checkout-*', metadata.name) ``.
- **JSON literal (backtick)** — for anything that isn't a bare string: numbers, booleans, arrays, or a JSON-encoded string: `` truncate(@, `9`) ``, `` enabled == `true` ``.

```sh
kyverno jp query -i pod.json -u "metadata.labels.team == 'checkout'"
```

> [!WARNING]
> **Common pitfall**
>
> Writing `` metadata.labels.team == `checkout` `` (backticks around a bare word) is invalid — a backtick literal must be valid JSON, and `checkout` alone isn't a JSON value (it would need to be `` `"checkout"` ``, JSON-string-inside-backticks). The single-quoted raw string `'checkout'` is the correct, simpler way to write a string literal. Reach for backticks only for numbers, booleans, `null`, or arrays/objects.

## Debugging before it ever touches a policy

The real payoff of `kyverno jp` is the loop it replaces. Without it, testing a `context`/`preconditions` expression means: edit the policy YAML, `kubectl apply`, trigger an admission event, then read Kyverno's logs or a `PolicyReport` to see what the expression actually evaluated to. With `kyverno jp`, you paste a representative JSON payload into a file once and iterate on the expression locally in seconds — no cluster round-trip required.

> [!TIP]
> **Try it — matching your dev loop to a real precondition**
>
> If a policy's `preconditions` will eventually check `request.object.metadata.labels.team`, save a representative `AdmissionReview`-shaped (or just the resource-shaped) JSON to a file and iterate there first:
>
> ```sh
> kyverno jp query -i request.json -u 'request.object.metadata.labels.team'
> ```
>
> Only copy the expression into the policy once `kyverno jp` shows it returning exactly what you expect.

## Reference

- `kyverno jp query --help` — the authoritative, version-matched flag reference for your installed CLI.
- [JMESPath specification](https://jmespath.org/specification.html) — the full stock language grammar Kyverno's engine implements, before any custom functions are added.
