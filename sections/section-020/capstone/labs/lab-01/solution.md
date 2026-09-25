# Solution Walkthrough

Follow these steps to mock a `context` lookup offline, then prove the same policy resolves it for real once it's live:

---

## Step 1: Offline Apply with a Mocked ConfigMap Context

```sh
cd /root/apply-capstone
kyverno apply policy.yaml \
  --resource good-img.yaml \
  --resource bad-img.yaml \
  -f values.yaml \
  > offline-results.txt
```

`values.yaml` supplies `globalValues["approvedRegistry.data.registry"]` — note the dotted key. A `configMap` context entry populates a `.data`/`.metadata` object, not a bare scalar, so the rule's `{{ approvedRegistry.data.registry }}` reference needs a values-file key that matches that same dotted path exactly. Without it, `kyverno apply` can't resolve the variable offline and would report an `error`, not a real pass/fail.

Confirm `offline-results.txt` ends with:
```text
pass: 1, fail: 1, warn: 0, error: 0, skip: 0
```

---

## Step 2: Apply the Policy Live

```sh
kubectl apply -f policy.yaml
kubectl get clusterpolicy check-registry-cm
```

---

## Step 3: Confirm the Trusted Image is Admitted

```sh
kubectl apply -f good-img.yaml
kubectl -n apps get pod trusted-app
```

Live, Kyverno's admission controller reads `registry-config` from the `platform` namespace for real — no mock needed, because a real cluster is right there to ask.

---

## Step 4: Confirm the Untrusted Image is Rejected

```sh
kubectl apply -f bad-img.yaml
```

Expect the API server to reject this with an admission error referencing `check-registry-cm`, similar to:
```text
Error from server: admission webhook "validate.kyverno.svc-fail" denied the request:

resource Pod/apps/untrusted-app was blocked due to the following policies

check-registry-cm:
  check-registry: 'validation error: Container images must start with registry.internal/.
    rule check-registry failed at path /spec/containers/0/image/'
```

---

## Step 5: Cluster Apply with a Policy Report — No Mock Needed

```sh
kyverno apply policy.yaml --cluster --namespace apps --policy-report \
  > cluster-report.yaml
```

Because `--cluster` gives Kyverno a real API server to fetch `registry-config` from, no `-f`/`--set` is required this time — the exact same policy that needed a mocked value offline in Step 1 now resolves its `context` for real. `cluster-report.yaml` should show `trusted-app` with `result: pass`.

This is the core lesson of the section: `kyverno apply` evaluates identically offline and against a cluster — the only thing that changes is where a `context` lookup's data comes from, and whether you need to hand it a mock.
