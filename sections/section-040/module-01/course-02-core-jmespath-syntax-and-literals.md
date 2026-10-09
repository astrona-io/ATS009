# Core JMESPath Syntax And Literals

Astronaut, a navigation computer is only as good as the questions you ask it. This part teaches the handful of JMESPath moves that cover almost every Kyverno policy: walking down into a document, picking one item from a list, asking every item at once, keeping only the items that fit, and passing an answer on to the next step. It ends with the one mistake that trips up most first attempts: writing a literal value the wrong way.

Every command below queries the same small document. Save this as `pod.json`, a cut-down Pod with one label and two containers:

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

## Five moves that cover most policies

Each move below is shown with a real query against `pod.json`, then summed up in a table.

### One item, or every item?

Ask for the name of the first container, then for the names of all containers:

```sh
kyverno jp query -i pod.json -u 'spec.containers[0].name'
kyverno jp query -i pod.json -u 'spec.containers[*].name'
```

```text
# spec.containers[0].name
web
# spec.containers[*].name
[
  "web",
  "sidecar"
]
```

`[0]` picks one item from the list, so you get one plain value. `[*]` is a projection: it asks every ship in the squadron at once and gives back a list. Mixing these two up is one of the most common reasons a Kyverno variable ends up holding a list when you expected a single value.

### Keep only what fits, then pass it on

Ask for the image of the container named `web`, then for the length of the Pod's name:

```sh
kyverno jp query -i pod.json -u "spec.containers[?name=='web'].image"
kyverno jp query -i pod.json -u 'metadata.name | length(@)'
```

```text
# spec.containers[?name=='web'].image
[
  "registry.example.com/checkout/web:1.4.2"
]
# metadata.name | length(@)
18
```

`[?...]` is a filter: it keeps only the ships that fit a condition. A filter always returns a list, even when only one item fits. `|` is a pipe: it hands the answer on to the next station, where `@` stands for "the value I was just given".

### The moves in one table

| Expression | Result | What it does |
| --- | --- | --- |
| `metadata.name` | `"checkout-web-7f8c9"` | Dot notation walks down nested object keys |
| `spec.containers[0].image` | `"registry.example.com/checkout/web:1.4.2"` | `[N]` picks one item from a list |
| `spec.containers[*].name` | `["web", "sidecar"]` | `[*]` projects: it applies the rest of the expression to every item |
| `spec.containers[?name=='web'].image` | `["registry.example.com/checkout/web:1.4.2"]` | `[?...]` is a filter expression |
| `metadata.name \| length(@)` | `18` | `\|` pipes a result into the next expression; `@` is the current value |

## Literals: raw strings and JSON literals

JMESPath has two ways to write a fixed value inside an expression. Mixing them up is a common source of errors, so learn the difference now.

### Compare a label with a string

Check whether the `team` label is `checkout`, first with single quotes, then with backticks:

```sh
kyverno jp query -i pod.json -u "metadata.labels.team == 'checkout'"
kyverno jp query -i pod.json -u 'metadata.labels.team == `checkout`'
```

```text
# metadata.labels.team == 'checkout'
true
Error: failed to compile JMESPath: metadata.labels.team == `checkout`, error: invalid character 'c' looking for beginning of value
```

The first one works. The second one does not even compile. A backtick literal must be valid JSON, and the bare word `checkout` is not a JSON value. As JSON it would have to be `` `"checkout"` ``, a JSON string inside backticks.

### The rule

- **Raw string literal, in single quotes**: plain words, for comparing with a string field. For example `name=='checkout'` or `pattern_match('checkout-*', metadata.name)`.
- **JSON literal, in backticks**: a coded value that is not a bare string: a number, `true` or `false`, `null`, a list or an object. For example `` truncate(@, `9`) `` or `` enabled == `true` ``.

A number needs its backticks too. `` metadata.name | truncate(@, `9`) `` returns `checkout-`, but `metadata.name | truncate(@, 9)` fails with `SyntaxError: Invalid token: tNumber`.

## Debug before it touches a policy

The real payoff of `kyverno jp` is the loop it replaces. Without it, testing a `context` or `preconditions` expression means: edit the policy YAML, `kubectl apply` it, trigger an admission request, then read Kyverno's logs or a policy report to see what the expression returned. With `kyverno jp`, you save a typical JSON document once and try the expression locally in seconds.

### Try a path that does not exist

Ask for a label the Pod does not have:

```sh
kyverno jp query -i pod.json -u 'metadata.labels.missing'
```

```text
Error: error evaluating JMESPath expression: Unknown key "missing" in path
```

Kyverno's engine reports a missing key as an error, instead of quietly giving you an empty answer. That is exactly the kind of surprise you want to see on your console, not inside a live policy.

> [!TIP]
> If a policy's `preconditions` will check `request.object.metadata.labels.team`, save a document shaped like the admission request (or just like the resource) to a file, and try the expression there first, for example `kyverno jp query -i request.json -u 'request.object.metadata.labels.team'`. Copy it into the policy only when `kyverno jp` returns exactly what you expect.

## Common pitfalls

> [!WARNING]
> - **Expecting one value from a projection.** `[*]` and `[?...]` always return a list. Use `[0]`, or pipe the list on, when you need a single value.
> - **Backticks around a bare word.** `` `checkout` `` is not valid JSON and fails to compile. Use `'checkout'`.
> - **A number without backticks.** `truncate(@, 9)` fails; write `` truncate(@, `9`) ``.
> - **Shell quoting.** An expression with single quotes inside must be wrapped in double quotes on the command line, and one with backticks is safest in single quotes.
