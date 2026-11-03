# Solution Walkthrough

Four steps: write the two expected files, write the manifest, run it, and break it once to see it fail. The test never changes the policies. It compares their real output with your files.

---

## Step 1: Write the expected patched Pod

Move into the lab folder and look at the mutate policy and the Pod:

```sh
cd ~/kyverno-cli-lab
cat add-managed-by.yaml web-pod.yaml
```

The rule adds `managed-by: kyverno` to Pods labelled `tier: web`. Save the whole Pod, with the new label, as `web-pod-patched.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
  labels:
    tier: web
    managed-by: kyverno
spec:
  containers:
    - name: app
      image: nginx:1.25-alpine
```

---

## Step 2: Write the expected generated resource

Look at the generate policy:

```sh
cat add-default-deny.yaml team-a-namespace.yaml
```

The rule builds a `NetworkPolicy` named `default-deny` in the namespace of the trigger. Save the expected result as `default-deny-generated.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: team-a
spec:
  podSelector: {}
  policyTypes:
    - Ingress
```

---

## Step 3: Write the test manifest

Save this as `kyverno-test.yaml`:

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: mutate-and-generate-tests
policies:
  - add-managed-by.yaml
  - add-default-deny.yaml
resources:
  - web-pod.yaml
  - batch-pod.yaml
  - team-a-namespace.yaml
results:
  - policy: add-managed-by
    rule: set-managed-by
    resources:
      - web-pod
    kind: Pod
    patchedResources: web-pod-patched.yaml
    result: pass
  - policy: add-managed-by
    rule: set-managed-by
    resources:
      - batch-pod
    kind: Pod
    result: skip
  - policy: add-default-deny
    rule: create-default-deny
    resources:
      - team-a
    kind: Namespace
    generatedResource: default-deny-generated.yaml
    result: pass
```

Three things to notice:

*   `web-pod` gets `result: pass` together with `patchedResources`: the rule runs, and its output must equal your file.
*   `batch-pod` gets `result: skip`: the rule does not apply to it, because its label is `tier: batch`.
*   For `team-a`, `resources` and `kind` name the trigger, the Namespace. The NetworkPolicy lives in the `generatedResource` file.

---

## Step 4: Run it and break it once

```sh
kyverno test .
echo $?
```

All three claims match, the summary reports three passed tests, and the exit code is `0`.

Now change `Ingress` to `Egress` in `default-deny-generated.yaml` and run the suite again. The generate claim fails with the reason `Resource diff`, and the exit code is not `0`. Change it back to `Ingress`.

The grader does the same kind of break in a scratch copy of the folder. It changes the label the policy paints, it changes the policy type the policy builds, and it gives `batch-pod` the label `tier: web`. A correct suite must fail each time, because each claim is then false.

> [!TIP]
> A `Resource diff` says that two resources differ. It does not say which one is right. When it appears, read the policy and the expected file side by side before you decide what to change.

---

## Submit

Send the mission for grading:

```sh
astrona submit -c sections/section-030/module-02/labs/lab-01
```
