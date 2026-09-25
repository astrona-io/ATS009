# Part 1 — Offline Policy Apply

> Prerequisite: [Landing page](./course.md). Next: [Part 2 — Applying Against a Live Cluster & Policy Reports](./course-02-applying-against-a-live-cluster-and-policy-reports.md).

## Apply needs no cluster at all

The single most important fact about `kyverno apply` in its default mode: **it does not touch a cluster.** You give it a policy file and one or more resource files, and it evaluates the policy's rules against those resources entirely in-process, the same way the admission controller's rule engine would, but with nothing to install, nothing to wait on, and nothing that can accidentally affect production.

```sh
kyverno apply policy.yaml --resource=resource1.yaml --resource=resource2.yaml
```

`--resource` (short form `-r`) is repeatable — pass it once per file. You can also point it at a whole directory of resources, or apply against a folder of policies at once:

```sh
kyverno apply policy.yaml --resource=./resources/
kyverno apply ./policies/ --resource=./resources/
```

## Reading the summary

Every `apply` run ends with a one-line summary:

```text
pass: 1, fail: 1, warn: 0, error: 0, skip: 0
```

| Category | Meaning |
| --- | --- |
| `pass` | The resource satisfied the rule. |
| `fail` | The resource violated the rule (would be rejected under `Enforce`). |
| `warn` | The rule matched but is configured to warn rather than fail (see `--audit-warn`). |
| `error` | Kyverno couldn't evaluate the rule at all — a malformed policy, a missing variable, etc. — distinct from a legitimate `fail`. |
| `skip` | The rule didn't apply to this resource (its `match`/`exclude` block excluded it). |

> [!WARNING]
> **Common pitfall**
>
> A non-zero `fail` or `error` count means `kyverno apply` exits with a non-zero exit code. This is exactly what makes `apply` usable as a CI gate — but it also means a script that runs `kyverno apply ...` and ignores its exit status will silently swallow real policy violations. Always check `$?` (or let your CI runner do it for you by not swallowing the command's exit code).

## Supplying variables with a values file

A Kyverno rule can't reference just any `{{ freeform }}` name — policy validation only accepts variables that come from a recognized source: `request.*` (the incoming object/user info), `element`/`elementIndex` (inside a `foreach`), `images.*`/`image.*`, or a name the rule itself declares in a `context` entry (a `configMap` lookup, an `apiCall`, or a computed `variable`). `request.object.*` variables are answered directly by whichever resource file you pass with `--resource` — no values file needed, since that *is* the object being evaluated.

Where a values file earns its keep is a `context` entry that reaches outside the resource itself — a `configMap` or `apiCall` lookup — which simply isn't reachable when there's no cluster. The `-f`/`--values-file` flag points at a YAML file that pre-seeds a value for that context variable, so `apply` uses your mock instead of trying (and failing) to reach the external source:

```yaml
policies:
  - name: require-approved-registry
    resources:
      - name: web-pod
        values:
          approvedRegistry: registry.internal/
```

```sh
kyverno apply policy.yaml --resource=resource.yaml -f values.yaml
```

For a single quick value without writing a whole values file, `--set` works inline:

```sh
kyverno apply policy.yaml --resource=resource.yaml --set approvedRegistry=registry.internal/
```

> [!WARNING]
> **Common pitfall**
>
> `-f`/`--set` only pre-seeds a value for a variable the rule already declares via `context` (or a `request.*`/`images.*` name) — it can't invent a brand-new free-floating variable name. A rule that references `{{ someName }}` without a matching `context` entry fails policy validation outright, before any resource is even evaluated, with an error naming `someName` as not matching Kyverno's allowed variable patterns.
>
> Also note: if the `context` entry itself computes a static value (a `variable` context type, rather than an external `configMap`/`apiCall` lookup), that computed value takes precedence over anything supplied via `-f`/`--set` — the mock only "wins" for context types that would otherwise need real external data.

If a policy references a variable this way and you run `apply` without supplying a mock, expect an `error` result (not a `fail`) — Kyverno couldn't finish evaluating the rule at all, which is a different, more diagnostic-worthy failure mode than a legitimate policy violation.

## Reference

- `kyverno apply --help` — the authoritative, version-matched flag list.
- [`kyverno apply` reference](https://kyverno.io/docs/kyverno-cli/reference/kyverno_apply/) — official documentation with the complete flag table.
