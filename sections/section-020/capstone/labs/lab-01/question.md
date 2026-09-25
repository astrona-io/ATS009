# Question

Solve this question on: `terminal`

The namespaces `apps` and `platform` already exist. A real `ConfigMap` named `registry-config` already exists in `platform`, with `data.registry: registry.internal/`. The policy and resource fixtures are on disk in `/root/apply-capstone/`: `policy.yaml`, `good-img.yaml`, `bad-img.yaml`, `values.yaml`. The policy's `context` reads `approvedRegistry` from that `ConfigMap`, and its rule requires every container image in `apps` to start with `{{ approvedRegistry.data.registry }}`.

1.  Run `kyverno apply` **offline** with `/root/apply-capstone/policy.yaml` against both `good-img.yaml` and `bad-img.yaml`, supplying `/root/apply-capstone/values.yaml` with `-f` to mock the `ConfigMap` lookup (unreachable offline). Redirect the output to `/root/apply-capstone/offline-results.txt`.
2.  Apply the policy to the live cluster with `kubectl apply -f /root/apply-capstone/policy.yaml`.
3.  Create a Pod named `trusted-app` in `apps` using the image from `good-img.yaml`, and confirm it is admitted.
4.  Attempt to create a Pod named `untrusted-app` in `apps` using the image from `bad-img.yaml`, and confirm the API server rejects it.
5.  Run `kyverno apply /root/apply-capstone/policy.yaml --cluster --namespace apps --policy-report` — this time **without** `-f`, since the live cluster can read the real `ConfigMap` itself — and redirect the output to `/root/apply-capstone/cluster-report.yaml`.
