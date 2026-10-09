# Question

Solve this question on: `terminal`

Astronaut, your capstone mission: check a rule that needs outside data, first with a prepared answer sheet and then against the real thing. The namespaces `apps` and `platform` already exist. A real `ConfigMap` named `registry-config` exists in `platform`, with `data.registry: registry.internal/`. The policy and resource files are on disk in `/root/apply-capstone/`: `policy.yaml`, `good-img.yaml`, `bad-img.yaml` and `values.yaml`. The policy's `context` entry reads `approvedRegistry` from that `ConfigMap`, and its rule requires every container image in `apps` to start with `{{ approvedRegistry.data.registry }}`.

1.  Run `kyverno apply` **offline** with `/root/apply-capstone/policy.yaml` against both `good-img.yaml` and `bad-img.yaml`, supplying `/root/apply-capstone/values.yaml` with `-f` to stand in for the `ConfigMap` lookup (it cannot be reached offline). Redirect the output to `/root/apply-capstone/offline-results.txt`.
2.  Apply the policy to the live cluster with `kubectl apply -f /root/apply-capstone/policy.yaml`.
3.  Create a Pod named `trusted-app` in `apps` using the image from `good-img.yaml`, and confirm it is admitted.
4.  Try to create a Pod named `untrusted-app` in `apps` using the image from `bad-img.yaml`, and confirm the API server rejects it.
5.  Run `kyverno apply /root/apply-capstone/policy.yaml --cluster --namespace apps --policy-report`, this time **without** `-f`, because the live cluster can read the real `ConfigMap` itself. Redirect the output to `/root/apply-capstone/cluster-report.yaml`.

The grader checks that `offline-results.txt` names both Pods and shows a 1 pass, 1 fail summary, that the live `check-registry-cm` policy is `Enforce`, that `trusted-app` runs with a `registry.internal/` image, that `untrusted-app` does not exist, and that `cluster-report.yaml` is a `ClusterPolicyReport` showing `trusted-app` with `result: pass`.
