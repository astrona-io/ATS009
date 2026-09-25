# Part 1 — Test Manifest Anatomy

> Prerequisite: [Landing page](./course.md). Next: [Part 2 — Running & Interpreting Test Results](./course-02-running-and-interpreting-test-results.md).

## What a test manifest actually asserts

A `kyverno-test.yaml` file is not a script — it's a claim. It names a set of policy files and resource files, and then states, resource by resource, what Kyverno *should* decide when it evaluates them: admit, reject, skip, or warn. `kyverno test` runs that evaluation for real and compares the claim to reality. If they match, every case passes. If even one doesn't, the run fails and tells you exactly which assertion was wrong.

This is what makes it fundamentally different from `kyverno apply`: `apply` shows you what happens once; `test` locks in what must *always* happen, and catches the day someone's policy edit silently changes that.

## Top-level schema

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: policy-tests
policies:
  - require-run-as-nonroot.yaml
resources:
  - good-pod.yaml
  - bad-pod.yaml
variables: variables.yaml     # optional
userinfo: userinfo.yaml       # optional
results:
  - policy: require-run-as-nonroot
    rule: check-runAsNonRoot
    resources:
      - good-pod
    kind: Pod
    result: pass
  - policy: require-run-as-nonroot
    rule: check-runAsNonRoot
    resources:
      - bad-pod
    kind: Pod
    result: fail
```

| Field | Purpose |
| --- | --- |
| `apiVersion` / `kind` | Always `cli.kyverno.io/v1alpha1` / `Test` — this is a CLI-only manifest kind, never applied to a cluster. |
| `policies` | File paths (relative to the manifest) to every policy under test. |
| `resources` | File paths to every resource the policies are evaluated against. Can also point at a directory. |
| `variables` | Optional path to a values file supplying policy/rule/resource-scoped variables, in the same format accepted by `kyverno apply -f`. |
| `userinfo` | Optional path to a file supplying admission-request identity (`clusterRoles`, `username`, `roles`) for policies whose rules depend on the requesting subject. |
| `results` | The list of assertions — this is the part you actually write and maintain. |

## Anatomy of a `results` entry

Each entry names one policy/rule pair and one or more resources, and declares the single outcome expected for all of them:

- **`policy`** — the policy's `metadata.name` (or `<namespace>/<name>` for a namespaced `Policy`).
- **`rule`** — the specific rule name inside that policy being asserted. Required for ordinary Kyverno policies.
- **`resources`** — a list of resource names (their `metadata.name`, not their file path) this assertion covers.
- **`kind`** — the Kubernetes kind of those resources.
- **`result`** — the expected outcome: `pass`, `fail`, `skip`, or `warn`.
- **`patchedResources`** — (mutate rules only) a file containing the resource *after* the expected patch, so `test` can diff it against Kyverno's real mutation output.
- **`generatedResource`** / **`cloneSourceResource`** — (generate rules only) the expected generated object, and the source object a `clone` generate rule should have copied from.

> [!TIP]
> **Try it — see a minimal test fail on purpose**
>
> Take any `results` entry you've written and flip its `result` to the wrong value. Run `kyverno test .`. The output names the exact policy, rule, and resource that disagreed with your claim — that's the signal you're building CI around, not a pass/fail summary alone.

## What the four result values mean

- **`pass`** — the resource satisfied the rule (for `validate`) or was successfully mutated/generated as declared.
- **`fail`** — the resource was rejected by a `validate` rule (or, for a `deny`-style rule, matched the deny condition).
- **`skip`** — the rule never evaluated this resource at all, typically because it didn't match the rule's `match`/`exclude` block.
- **`warn`** — the rule's `validationFailureAction` is set to warn-style behavior (or `Audit` combined with certain reporting settings), so the resource is admitted but flagged.

## Grouping resources under one entry — and the pitfall

`resources:` accepts a list precisely so you don't repeat identical entries for several resources that all produce the same outcome — five compliant Pods can share one `result: pass` entry. But every resource named in that list must genuinely produce that *same* outcome. Grouping two resources with different real outcomes under one shared `result` doesn't average out or partially pass — `kyverno test` fails the whole entry the moment it finds one resource in the list whose actual evaluation disagrees with the declared value.

> [!WARNING]
> **Common pitfall**
>
> It's tempting, when a test fails, to "fix" it by deleting the resource that doesn't match your expectation rather than correcting the expectation (or the policy). That produces a suite that always passes and asserts nothing. A shrinking `results` list with a growing pass rate is a red flag, not progress — use `--require-tests` (covered in Part 2) to catch a suite that's been hollowed out this way.

## Reference

- `kyverno test --help` — the live flag reference for your installed CLI version.
- The Kyverno CLI's testing-policies guide for additional `variables`/`userinfo` file examples.
