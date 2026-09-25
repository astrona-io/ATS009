# Question

Solve this question on: `terminal`

Your working directory is `~/kyverno-cli-lab`. It already contains two policies and four resources, but **no `kyverno-test.yaml`**:

*   `require-run-as-nonroot.yaml` — requires `spec.securityContext.runAsNonRoot: true` on every Pod (rule `check-runAsNonRoot`).
*   `disallow-latest-tag.yaml` — requires every container image to carry an explicit tag (rule `require-image-tag`) and forbids the `:latest` tag specifically (rule `validate-image-tag`).
*   `good-pod.yaml`, `bad-nonroot-pod.yaml`, `bad-image-pod.yaml`, `bad-both-pod.yaml`.

1.  Work out, for each of the three rules above, what Kyverno actually decides for each of the four Pods — you can use `kyverno apply` to check your reasoning if you want.
2.  Write a `kyverno-test.yaml` from scratch that correctly asserts every rule/resource outcome. Group resource names under a single `results` entry wherever their expected outcome for a given rule is identical, instead of writing one entry per resource.
3.  Run `kyverno test . --require-tests` and confirm it exits `0`.
