# Solution Walkthrough

Follow these steps to work out the real outcomes and encode them correctly.

---

## Step 1: Work Out Each Rule/Resource Outcome

| Resource | `securityContext.runAsNonRoot` | image | `check-runAsNonRoot` | `require-image-tag` | `validate-image-tag` |
| --- | --- | --- | --- | --- | --- |
| `good-pod` | `true` | `nginx:1.25-alpine` | pass | pass | pass |
| `bad-nonroot-pod` | *(absent)* | `nginx:1.25-alpine` | **fail** | pass | pass |
| `bad-image-pod` | `true` | `nginx:latest` | pass | pass | **fail** |
| `bad-both-pod` | *(absent)* | `nginx:latest` | **fail** | pass | **fail** |

`require-image-tag` passes for all four — every Pod here specifies *some* tag, even the ones that fail `validate-image-tag` by using `:latest` specifically. You can confirm any of these with `kyverno apply require-run-as-nonroot.yaml disallow-latest-tag.yaml -r <file>.yaml`.

---

## Step 2: Write the Test Manifest

Group by rule, then by shared outcome:

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: capstone-tests
policies:
  - require-run-as-nonroot.yaml
  - disallow-latest-tag.yaml
resources:
  - good-pod.yaml
  - bad-nonroot-pod.yaml
  - bad-image-pod.yaml
  - bad-both-pod.yaml
results:
  - policy: require-run-as-nonroot
    rule: check-runAsNonRoot
    resources:
      - good-pod
      - bad-image-pod
    kind: Pod
    result: pass
  - policy: require-run-as-nonroot
    rule: check-runAsNonRoot
    resources:
      - bad-nonroot-pod
      - bad-both-pod
    kind: Pod
    result: fail
  - policy: disallow-latest-tag
    rule: require-image-tag
    resources:
      - good-pod
      - bad-nonroot-pod
      - bad-image-pod
      - bad-both-pod
    kind: Pod
    result: pass
  - policy: disallow-latest-tag
    rule: validate-image-tag
    resources:
      - good-pod
      - bad-nonroot-pod
    kind: Pod
    result: pass
  - policy: disallow-latest-tag
    rule: validate-image-tag
    resources:
      - bad-image-pod
      - bad-both-pod
    kind: Pod
    result: fail
```

Five entries cover all twelve rule/resource combinations, because grouping collapses every case that shares an outcome for a given rule.

---

## Step 3: Confirm

```sh
kyverno test . --require-tests
```

All twelve checks pass, and the command exits `0`. Notice that `require-image-tag` needed only one entry naming all four resources — it's the one rule in this capstone where every resource shares the same real outcome.
