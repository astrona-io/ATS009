# Solution Walkthrough

Five steps: check the rule offline with an answer sheet, switch it on, watch the inspector admit one ship and turn one away, then audit the planet with no answer sheet at all.

---

## Step 1: Offline apply with a mocked ConfigMap lookup

Move into the capstone folder and check both Pod files, with the values file standing in for the `ConfigMap`:

```sh
cd /root/apply-capstone
kyverno apply policy.yaml \
  --resource good-img.yaml \
  --resource bad-img.yaml \
  -f values.yaml \
  > offline-results.txt
```

`values.yaml` sets `globalValues["approvedRegistry.data.registry"]`. Note the dotted key. A `configMap` context entry fills `approvedRegistry` with the whole object (its `data`, its `metadata`), not a single value. The rule reads `{{ approvedRegistry.data.registry }}`, so the values file needs a key with exactly that path. Without it, `kyverno apply` cannot fill the variable offline and reports an `error`, not a real pass or fail.

Look at the file:

```sh
cat offline-results.txt
```

```text
Applying 3 policy rule(s) to 2 resource(s)...
policy check-registry-cm -> resource apps/Pod/untrusted-app failed:
1 - check-registry validation error: Container images must start with registry.internal/. rule check-registry failed at path /spec/containers/0/image/


pass: 1, fail: 1, warn: 0, error: 0, skip: 0
```

`untrusted-app` fails, because its image comes from `docker.io`. `trusted-app` passes and is counted in the summary line.

---

## Step 2: Apply the policy live

Hand the policy to the cluster, then check that it exists:

```sh
kubectl apply -f policy.yaml
kubectl get clusterpolicy check-registry-cm
```

---

## Step 3: Confirm the trusted image is admitted

Create the trusted Pod from its file, then check that it exists:

```sh
kubectl apply -f good-img.yaml
kubectl -n apps get pod trusted-app
```

Now that the policy is live, the Kyverno admission controller reads `registry-config` from the namespace `platform` for real. No answer sheet is needed: a real cluster is right there to ask.

---

## Step 4: Confirm the untrusted image is rejected

Try to create the untrusted Pod:

```sh
kubectl apply -f bad-img.yaml
```

The API server asks Kyverno's admission webhook, and Kyverno rejects the Pod with an error that names `check-registry-cm`, similar to:

```text
Error from server: admission webhook "validate.kyverno.svc-fail" denied the request:

resource Pod/apps/untrusted-app was blocked due to the following policies

check-registry-cm:
  check-registry: 'validation error: Container images must start with registry.internal/.
    rule check-registry failed at path /spec/containers/0/image/'
```

---

## Step 5: Cluster apply with a policy report, no mock needed

Audit the live namespace and save the report:

```sh
kyverno apply policy.yaml --cluster --namespace apps --policy-report \
  > cluster-report.yaml
```

With `--cluster`, the Kyverno CLI has a real API server to fetch `registry-config` from, so `-f` and `--set` are not needed. The same policy that needed an answer sheet in Step 1 now fills its `context` entry for real. `cluster-report.yaml` shows `trusted-app` with `result: pass`.

This is the main lesson of the capstone: `kyverno apply` checks a policy the same way offline and against a cluster. The only thing that changes is where a `context` lookup gets its data, and whether you must hand it a mock.

---

## Submit

Send the mission for grading:

```sh
astrona submit -c sections/section-020/capstone/labs/lab-01
```
