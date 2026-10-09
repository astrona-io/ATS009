# Test Manifest Anatomy

Astronaut, a `kyverno-test.yaml` file is not a script. It is a claim. It names some policy files and some resource files, then states, resource by resource, what Kyverno *should* decide about each one: clear it, turn it away, skip it, or clear it with a warning. `kyverno test` runs the real check and compares your claim with the result. If they match, every case passes. If even one does not, the run fails and names the line of the checklist that was wrong.

That is the difference from `kyverno apply`. `apply` shows you what happens once. `test` locks in what must *always* happen, and catches the day an edit to a policy quietly changes it.

## Build a small suite

The fastest way to understand the file is to build a working suite from four small files and run it once.

### Save the policy and two Pods

Save this as `require-run-as-nonroot.yaml`. It requires every Pod to set `spec.securityContext.runAsNonRoot: true`, so no crew member runs the ship as the all-powerful root user:

```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-run-as-nonroot
spec:
  validationFailureAction: Enforce
  background: false
  rules:
    - name: check-runAsNonRoot
      match:
        any:
        - resources:
            kinds:
              - Pod
      validate:
        message: "spec.securityContext.runAsNonRoot must be set to true."
        pattern:
          spec:
            securityContext:
              runAsNonRoot: true
```

Save this as `good-pod.yaml`. It sets the field:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: good-pod
spec:
  securityContext:
    runAsNonRoot: true
  containers:
    - name: app
      image: nginx:alpine
```

Save this as `bad-pod.yaml`. It has no `securityContext` at all:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: bad-pod
spec:
  containers:
    - name: app
      image: nginx:alpine
```

### Save the test manifest

Save this as `kyverno-test.yaml`, in the same folder as the three files above:

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

The manifest claims that `good-pod` passes the rule and `bad-pod` fails it.

### Run the suite

Run the test in the current folder:

```sh
kyverno test .
```

```text
Loading test  ( kyverno-test.yaml ) ...
  Loading values/variables ...
  Loading policies ...
  Loading resources ...
  Loading exceptions ...
  Applying 1 policy to 2 resources ...
  Checking results ...

│────│────────────────────────│────────────────────│──────────────│────────│────────│
│ ID │ POLICY                 │ RULE               │ RESOURCE     │ RESULT │ REASON │
│────│────────────────────────│────────────────────│──────────────│────────│────────│
│ 1  │ require-run-as-nonroot │ check-runAsNonRoot │ Pod/good-pod │ Pass   │ Ok     │
│ 2  │ require-run-as-nonroot │ check-runAsNonRoot │ Pod/bad-pod  │ Pass   │ Ok     │
│────│────────────────────────│────────────────────│──────────────│────────│────────│


Test Summary: 2 tests passed and 0 tests failed
```

Read the `RESULT` column carefully. It says whether each **test** passed, not whether the Pod passed the policy. `bad-pod` really fails the rule, but the manifest expected exactly that, so its test row shows `Pass` with the reason `Ok`.

## The top-level fields

Now that you have seen a suite work, here is what each top-level field does:

| Field | What it does |
| --- | --- |
| `apiVersion` / `kind` | Always `cli.kyverno.io/v1alpha1` / `Test`. This kind exists only for the CLI. You never apply it to a cluster. |
| `policies` | Paths, relative to the manifest, to every policy under test. |
| `resources` | Paths to every resource the policies are checked against. A path can also be a folder. |
| `variables` | Optional. Path to a values file that supplies policy, rule or resource variables, in the same format `kyverno apply -f` accepts. |
| `userinfo` | Optional. Path to a file with the identity of the requester (`clusterRoles`, `username`, `roles`), for policies whose rules depend on who sends the request. |
| `results` | The list of claims. This is the part you write and maintain. |

The two optional fields sit at the top level, next to `resources`. This is only a piece of a manifest, so you do not save it:

```yaml
variables: variables.yaml     # optional
userinfo: userinfo.yaml       # optional
```

## Anatomy of a `results` entry

Each entry is one line of the checklist. It names one policy and rule, one or more resources, and the single verdict expected for all of them:

- **`policy`**: the policy's `metadata.name`, or `<namespace>/<name>` for a namespaced `Policy`.
- **`rule`**: the name of the rule inside that policy. Required for ordinary Kyverno policies.
- **`resources`**: a list of resource **names** (their `metadata.name`), not file paths.
- **`kind`**: the Kubernetes kind of those resources.
- **`result`**: the expected verdict: `pass`, `fail`, `skip` or `warn`.
- **`patchedResources`**: for `mutate` rules only. A file with the resource as it should look *after* the change, so `test` can compare it with Kyverno's real output.
- **`generatedResource`** and **`cloneSourceResource`**: for `generate` rules only. The object the rule should create, and the source object a `clone` rule should copy from.

## What the four verdicts mean

Each verdict is a claim about what the docking inspector would do with that ship:

- **`pass`**: the resource fits the rule (for `validate`), or was changed or created exactly as declared (for `mutate` and `generate`).
- **`fail`**: a `validate` rule rejects the resource, or the resource matches a `deny` condition.
- **`skip`**: the rule never looked at this resource, usually because its `match` or `exclude` block leaves it out.
- **`warn`**: the rule is set up to warn instead of reject, so the resource is cleared but flagged.

## Group resources that share a verdict

`resources:` is a list so that you do not repeat the same entry again and again. Five compliant Pods can share one `result: pass` entry.

There is one firm rule: every resource in that list must really get that **same** verdict. A group with mixed real verdicts does not average out or partly pass. `kyverno test` fails the whole entry as soon as one resource in the list disagrees with the declared value. That is why `good-pod` and `bad-pod` sit in two separate entries above.

> [!TIP]
> When a test fails, fix the claim or fix the policy, never the evidence. Deleting the resource that disagrees makes the suite pass and prove nothing. A `results` list that keeps getting shorter while the pass rate goes up is a red flag, not progress.

## Common pitfalls

> [!WARNING]
> - **Reading `RESULT` as the policy verdict.** In `kyverno test` output, `Pass` means "the real verdict matched the claim". A Pod that really fails the rule shows `Pass` when the manifest expected `fail`.
> - **Using file names in `results`.** `resources:` inside a `results` entry takes `metadata.name` values such as `bad-pod`, not `bad-pod.yaml`.
> - **Grouping resources with different real verdicts.** One mismatch fails the whole entry. Split the entry.
> - **"Fixing" a failure by deleting the case.** The suite then passes and asserts nothing. Correct the expected `result`, or correct the policy.
