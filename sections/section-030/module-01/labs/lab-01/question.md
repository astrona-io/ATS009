# Question

Solve this question on: `terminal`

Astronaut, your mission: a pre-flight checklist is lying, and you must make it tell the truth. Your working folder is `~/kyverno-cli-lab`. It already holds:

*   `require-run-as-nonroot.yaml`: a `ClusterPolicy` (rule `check-runAsNonRoot`) that requires every Pod to set `spec.securityContext.runAsNonRoot: true`.
*   `good-pod.yaml`: a Pod that sets `runAsNonRoot: true`.
*   `bad-pod.yaml`: a Pod that does **not** set a `securityContext` at all.
*   `kyverno-test.yaml`: a test manifest that currently asserts **`pass`** for both `good-pod` and `bad-pod` in a single `results` entry.

1.  Run `kyverno test .` and read the output to find out which of the two Pods Kyverno really clears, and which one it really turns away, under `require-run-as-nonroot`.
2.  Fix `kyverno-test.yaml` so it asserts the real verdict for each Pod. You may use one `results` entry per Pod or any other structure, as long as every expected `result` matches Kyverno's real verdict.
3.  Re-run `kyverno test .` and confirm it exits `0` with both cases reported. Do not delete `bad-pod` from the test manifest to make it pass the easy way.

The grader runs four checks in `~/kyverno-cli-lab`:

*   `kyverno-test.yaml` still has a `results` claim about both `good-pod` and `bad-pod`.
*   `kyverno test .` exits `0` and runs at least two tests.
*   The suite really asserts `good-pod`: if `good-pod` is changed so that it breaks the rule, the suite must fail.
*   The suite really asserts `bad-pod`: if `bad-pod` is repaired so that it passes the rule, the suite must fail.
