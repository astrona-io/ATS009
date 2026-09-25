# Question

Solve this question on: `terminal`

The namespace `apps` already exists with two live Pods: `compliant-app` (labeled `team: checkout`) and `legacy-app` (no `team` label). The policy and matching resource fixtures are already on disk in `/root/apply-lab/`: `policy.yaml`, `compliant-app.yaml`, `legacy-app.yaml`.

1.  Run `kyverno apply` **offline** (no `--cluster`) with `/root/apply-lab/policy.yaml` against both `/root/apply-lab/compliant-app.yaml` and `/root/apply-lab/legacy-app.yaml` in a single invocation, and redirect the full command output to `/root/apply-lab/offline-results.txt`.
2.  Apply the policy to the live cluster with `kubectl apply -f /root/apply-lab/policy.yaml`.
3.  Run `kyverno apply /root/apply-lab/policy.yaml --cluster --namespace apps --policy-report`, and redirect the output to `/root/apply-lab/cluster-report.yaml`.
4.  Attempt to create a third Pod named `new-app` in `apps` with no `team` label, and confirm the API server now rejects it (the policy is `Enforce`, so this only affects *new* admissions — `legacy-app` was admitted before the policy existed and is unaffected).
