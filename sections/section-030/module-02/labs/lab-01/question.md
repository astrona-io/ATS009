# Question

Solve this question on: `terminal`

Astronaut, your mission: write the pre-flight checklist for a repair crew and a dock crew. Your working folder is `~/kyverno-cli-lab`. It already holds:

*   `add-managed-by.yaml`: a `ClusterPolicy` with the mutate rule `set-managed-by`. It adds the label `managed-by: kyverno` to every Pod labelled `tier: web`.
*   `web-pod.yaml`: a Pod named `web-pod` labelled `tier: web`.
*   `batch-pod.yaml`: a Pod named `batch-pod` labelled `tier: batch`.
*   `add-default-deny.yaml`: a `ClusterPolicy` with the generate rule `create-default-deny`. For every new Namespace it builds a `NetworkPolicy` named `default-deny` in that namespace. The policy has an empty `podSelector` and the policy type `Ingress`.
*   `team-a-namespace.yaml`: a Namespace named `team-a`.

There is no `kyverno-test.yaml` and no expected-output file yet.

1.  Write `web-pod-patched.yaml`: the whole Pod `web-pod` as it must look after the rule `set-managed-by` ran.
2.  Write `default-deny-generated.yaml`: the `NetworkPolicy` that the rule `create-default-deny` must build for `team-a`.
3.  Write `kyverno-test.yaml` with both policies, all three resources and three `results` entries: the mutate pass for `web-pod` (with `patchedResources`), the mutate `skip` for `batch-pod`, and the generated resource for `team-a` (with `generatedResource`).
4.  Run `kyverno test .` and confirm it exits `0` with three cases reported.

The grader runs five checks in `~/kyverno-cli-lab`:

*   `kyverno-test.yaml` names both policies and all three resources, and uses `patchedResources`, `generatedResource` and a `skip` result.
*   `kyverno test .` exits `0` and at least three tests passed.
*   The suite really compares the mutate output: if the rule paints a different label value, the suite must fail.
*   The suite really compares the generated resource: if the rule builds an `Egress` policy instead, the suite must fail.
*   The suite really claims `skip` for `batch-pod`: if `batch-pod` gets the label `tier: web`, the suite must fail.

Do not edit the policy files or the resources to make the suite pass.
