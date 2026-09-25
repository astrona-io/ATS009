# Solution Walkthrough

Follow these steps to exercise `kyverno apply` offline, live, and as a policy report:

---

## Step 1: Offline Apply

```sh
cd /root/apply-lab
kyverno apply policy.yaml \
  --resource compliant-app.yaml \
  --resource legacy-app.yaml \
  > offline-results.txt
```

Open `offline-results.txt` and confirm it ends with:
```text
pass: 1, fail: 1, warn: 0, error: 0, skip: 0
```
`legacy-app` fails (no `team` label), `compliant-app` passes. No cluster was involved in this step at all.

---

## Step 2: Apply the Policy Live

```sh
kubectl apply -f policy.yaml
kubectl get clusterpolicy require-team-label
```

Confirm the policy is applied and ready. `legacy-app` is **not** retroactively affected — Kyverno's `validate` rules run at admission time, and `legacy-app` was already admitted before this policy existed.

---

## Step 3: Cluster Apply with a Policy Report

```sh
kyverno apply policy.yaml --cluster --namespace apps --policy-report \
  > cluster-report.yaml
```

`cluster-report.yaml` will contain a `ClusterPolicyReport` with two `results` entries — one `result: pass` for `compliant-app`, one `result: fail` for `legacy-app` — proving the report format matches exactly what offline apply predicted, just now sourced from live cluster objects instead of local files.

---

## Step 4: Confirm Live Enforcement on New Admissions

```sh
kubectl run new-app --image=nginx:alpine -n apps
```

Expect the API server to reject this with an admission error referencing `require-team-label`, similar to:
```text
Error from server: admission webhook "validate.kyverno.svc-fail" denied the request:

resource Pod/apps/new-app was blocked due to the following policies

require-team-label:
  check-team-label: 'validation error: A non-empty ''team'' label is required
    on every Pod in apps. rule check-team-label failed at path /metadata/labels/'
```

This confirms the policy is genuinely enforcing for new resources, even though `legacy-app` — created before the policy existed — continues to run untouched (the exact gap that Kyverno's background scanning and `PolicyReport`s, which you just previewed client-side in Step 3, exist to surface).
