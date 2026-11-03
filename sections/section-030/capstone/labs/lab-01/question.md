# Question

Solve this question on: `terminal`

Astronaut, your capstone mission: write a full pre-flight checklist from scratch. Your working folder is `~/kyverno-cli-lab`. It already holds two policies and four Pods, but **no `kyverno-test.yaml`**:

*   `require-run-as-nonroot.yaml`: requires `spec.securityContext.runAsNonRoot: true` on every Pod (rule `check-runAsNonRoot`).
*   `disallow-latest-tag.yaml`: requires every container image to carry an explicit tag (rule `require-image-tag`) and forbids the `:latest` tag in particular (rule `validate-image-tag`).
*   `good-pod.yaml`, `bad-nonroot-pod.yaml`, `bad-image-pod.yaml` and `bad-both-pod.yaml`.

1.  Work out, for each of the three rules, what Kyverno really decides for each of the four Pods. You can use `kyverno apply` to check your reasoning.
2.  Write a `kyverno-test.yaml` from scratch that correctly asserts every rule and Pod result. Wherever several Pods get the same verdict for a given rule, group their names under a single `results` entry instead of writing one entry per Pod.
3.  Run `kyverno test .` and confirm it exits `0` with all twelve cases (three rules for four Pods) reported.

The grader runs six checks in `~/kyverno-cli-lab`:

*   `kyverno-test.yaml` names both policies, all three rules and all four Pods in its `results` list.
*   `kyverno test .` exits `0` and reports twelve passed tests.
*   The `results` list has at most five entries, because Pods that share a verdict for a rule are grouped.
*   The suite really asserts the claims: if `good-pod` loses `runAsNonRoot`, if `good-pod` gets the `:latest` tag, or if `bad-both-pod` is repaired, the suite must fail.
