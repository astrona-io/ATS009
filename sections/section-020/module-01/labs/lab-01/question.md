# Question

Solve this question on: `terminal`

Astronaut, your mission: test a rule on paper, switch it on, and audit the planet. The namespace `apps` already has two running Pods: `compliant-app` (labelled `team: checkout`) and `legacy-app` (no `team` label). The policy and matching resource files are on disk in `/root/apply-lab/`: `policy.yaml` (the `ClusterPolicy` `require-team-label`, set to `Enforce`), `compliant-app.yaml` and `legacy-app.yaml`. The Kyverno controller and the `kyverno` CLI `1.13.2` are installed.

1.  Run `kyverno apply` **offline** (no `--cluster`) with `/root/apply-lab/policy.yaml` against both `/root/apply-lab/compliant-app.yaml` and `/root/apply-lab/legacy-app.yaml` in a single command, and redirect the full command output to `/root/apply-lab/offline-results.txt`.
2.  Apply the policy to the live cluster with `kubectl apply -f /root/apply-lab/policy.yaml`.
3.  Run `kyverno apply /root/apply-lab/policy.yaml --cluster --namespace apps --policy-report`, and redirect the output to `/root/apply-lab/cluster-report.yaml`.
4.  Try to create a third Pod named `new-app` in `apps` with no `team` label, and confirm the API server now rejects it. The policy is `Enforce`, so it only affects *new* admissions: `legacy-app` was admitted before the policy existed and keeps running.

The grader reads both files: `offline-results.txt` must name both Pods and show a 1 pass, 1 fail summary, and `cluster-report.yaml` must be a `ClusterPolicyReport` with a pass and a fail for the two Pods. It also checks that the live `require-team-label` policy is `Enforce`, that `legacy-app` still exists, and that `new-app` does not.
