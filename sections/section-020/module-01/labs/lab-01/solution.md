# Solution Walkthrough

Four steps, in the order a careful astronaut uses on a real cluster: test on paper, switch the rule on, audit what is already docked, then watch the inspector at work on a new ship.

---

## Step 1: Offline apply

Move into the lab folder and check the policy against both Pod files. No cluster is involved in this step:

```sh
cd /root/apply-lab
kyverno apply policy.yaml \
  --resource compliant-app.yaml \
  --resource legacy-app.yaml \
  > offline-results.txt
```

Look at the file:

```sh
cat offline-results.txt
```

```text
Applying 3 policy rule(s) to 2 resource(s)...
policy require-team-label -> resource apps/Pod/legacy-app failed:
1 - check-team-label validation error: A non-empty 'team' label is required on every Pod in apps. rule check-team-label failed at path /metadata/labels/


pass: 1, fail: 1, warn: 0, error: 0, skip: 0
```

`legacy-app` fails because it has no `team` label. `compliant-app` passes; the default output counts it in the summary line but does not list it by name.

---

## Step 2: Apply the policy live

Hand the policy to the cluster, then check that it exists:

```sh
kubectl apply -f policy.yaml
kubectl get clusterpolicy require-team-label
```

The Kyverno controller now checks every new Pod in `apps` through its admission webhook. `legacy-app` is **not** touched: `validate` rules run at admission time, and `legacy-app` was admitted before this policy existed.

---

## Step 3: Cluster apply with a policy report

Audit the live namespace and save the report:

```sh
kyverno apply policy.yaml --cluster --namespace apps --policy-report \
  > cluster-report.yaml
```

This time the Kyverno CLI reads the two Pods from the cluster instead of from files. `cluster-report.yaml` holds a `ClusterPolicyReport` with two `results` entries: `result: pass` for `compliant-app` and `result: fail` for `legacy-app`. That is exactly what the offline run predicted, now taken from live objects.

---

## Step 4: Confirm live enforcement on a new Pod

Try to start a new Pod with no `team` label:

```sh
kubectl run new-app --image=nginx:alpine -n apps
```

The API server asks Kyverno's admission webhook, and Kyverno rejects the Pod with an error that names `require-team-label`, similar to:

```text
Error from server: admission webhook "validate.kyverno.svc-fail" denied the request:

resource Pod/apps/new-app was blocked due to the following policies

require-team-label:
  check-team-label: 'validation error: A non-empty ''team'' label is required
    on every Pod in apps. rule check-team-label failed at path /metadata/labels/'
```

The policy enforces on new Pods, while `legacy-app`, created before the policy existed, keeps running. That gap is exactly what Kyverno's background scan and its `PolicyReport` objects exist to show; you previewed the same result on your side in Step 3.

---

## Submit

Send the mission for grading:

```sh
astrona submit -c sections/section-020/module-01/labs/lab-01
```
