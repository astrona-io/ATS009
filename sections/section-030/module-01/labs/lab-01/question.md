# Question

Solve this question on: `terminal`

Your working directory is `~/kyverno-cli-lab`. It already contains:

*   `require-run-as-nonroot.yaml` — a `ClusterPolicy` that requires every Pod to set `spec.securityContext.runAsNonRoot: true`.
*   `good-pod.yaml` — a Pod that sets `runAsNonRoot: true`.
*   `bad-pod.yaml` — a Pod that does **not** set a `securityContext` at all.
*   `kyverno-test.yaml` — a test manifest that currently asserts **`pass`** for both `good-pod` and `bad-pod` under a single `results` entry.

1.  Run `kyverno test .` and read the output to determine which of the two resources Kyverno actually admits, and which it actually rejects, against `require-run-as-nonroot`.
2.  Fix `kyverno-test.yaml` so it correctly and separately asserts the real outcome for each resource (one `results` entry per resource, or however you choose to structure it, as long as each expected `result` matches Kyverno's real evaluation).
3.  Re-run `kyverno test . --require-tests` and confirm it exits `0` with both cases reported correctly — do not simply delete `bad-pod` from the test manifest to make it pass trivially.
