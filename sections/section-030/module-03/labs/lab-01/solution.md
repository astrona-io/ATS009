# Solution Walkthrough

Four steps: make the folders, write three manifests, run them together, and break one input to see the suite fail. Every manifest points back at the shared inputs with `../../`.

---

## Step 1: Make the folders

```sh
cd ~/kyverno-cli-lab
mkdir -p tests/registry tests/platform-admin tests/platform-dev
```

Each manifest sits in `tests/<scenario>`, so its paths climb two folders up to reach `policies`, `resources`, `values` and `userinfo`.

---

## Step 2: Write the registry suite

Save this as `tests/registry/kyverno-test.yaml`:

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: registry-tests
policies:
  - ../../policies/restrict-registry.yaml
resources:
  - ../../resources/good-registry-pod.yaml
  - ../../resources/bad-registry-pod.yaml
  - ../../resources/legacy-pod.yaml
exceptions:
  - ../../policies/legacy-exception.yaml
variables: ../../values/registry-values.yaml
results:
  - policy: restrict-registry
    rule: check-registry
    resources:
      - good-registry-pod
    kind: Pod
    result: pass
  - policy: restrict-registry
    rule: check-registry
    resources:
      - bad-registry-pod
    kind: Pod
    result: fail
  - policy: restrict-registry
    rule: check-registry
    resources:
      - legacy-pod
    kind: Pod
    result: skip
```

The `variables` line fills the registry placeholder. The `exceptions` list frees `legacy-pod`, so its claim is `skip`. `bad-registry-pod` has no waiver and still fails.

---

## Step 3: Write the two badge suites

Save this as `tests/platform-admin/kyverno-test.yaml`:

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: platform-admin-tests
policies:
  - ../../policies/platform-admin-only.yaml
resources:
  - ../../resources/platform-pod.yaml
userinfo: ../../userinfo/admin.yaml
results:
  - policy: platform-admin-only
    rule: block-platform-tier
    resources:
      - platform-pod
    kind: Pod
    result: skip
```

Save this as `tests/platform-dev/kyverno-test.yaml`:

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: platform-dev-tests
policies:
  - ../../policies/platform-admin-only.yaml
resources:
  - ../../resources/platform-pod.yaml
userinfo: ../../userinfo/dev.yaml
results:
  - policy: platform-admin-only
    rule: block-platform-tier
    resources:
      - platform-pod
    kind: Pod
    result: fail
```

The admin badge is excluded by the rule, so the result is `skip`. The developer badge is not excluded, so the Pod is turned away: `fail`.

---

## Step 4: Run them together and break one

```sh
kyverno test .
echo $?
```

The summary reports five passed tests and the exit code is `0`. One command ran three manifests.

Now change `cluster-admin` to `edit` in `userinfo/admin.yaml` and run again. The admin claim fails, because that badge is no longer excluded. Change it back.

The grader makes the same kind of break in a scratch copy. It changes the approved registry, takes the admin role away, points the exception at another Pod and repairs `bad-registry-pod`. A correct suite must fail each time, because each claim is then false.

> [!TIP]
> A suite that uses an input must notice when the input changes. If a change to the values file, the badge or the waiver leaves the suite green, that input is not really tested.

---

## Submit

Send the mission for grading:

```sh
astrona submit -c sections/section-030/module-03/labs/lab-01
```
