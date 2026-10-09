# Supplying Variables With A Values File

Astronaut, some rules cannot be checked from the ship's papers alone. The inspector has to radio mission control for extra information first, for example "which shipyard is approved this week?" With no cluster in the loop, there is nobody to radio. A values file is a prepared answer sheet: you write the answer down in advance, and the scanner uses it instead of calling out.

This part shows a policy that needs outside data, what happens offline without an answer sheet, and how to supply one with `-f` or `--set`.

## Where policy variables come from

A Kyverno rule can use variables, written as `{{ ... }}`. Kyverno does not accept just any name there. A variable must come from a source Kyverno knows:

- `request.*`: the incoming object and the user who sent it. Offline, the resource file you pass with `--resource` **is** that object, so `request.object.*` needs no help.
- `element` and `elementIndex`: the current item inside a `foreach` loop.
- `images.*` and `image.*`: details of the container images in the resource.
- A name the rule declares itself in a `context` entry: a `configMap` lookup, an `apiCall`, or a computed `variable`.

A `context` entry that reads a `configMap` or calls the API reaches outside the resource. That is the information the inspector radios mission control for. Offline, there is no mission control, and that is where a values file earns its keep.

## A policy that needs mission control

Here is a real policy whose rule depends on a `ConfigMap` in the cluster. You will check two Pods against it, first without and then with an answer sheet.

### Save the policy and two Pods

Save this as `clusterpolicy-check-registry-cm.yaml`. Its `context` entry reads the `ConfigMap` `registry-config` from the namespace `platform`, and the rule requires every image in `apps` to start with the registry stored there:

```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: check-registry-cm
spec:
  validationFailureAction: Enforce
  background: true
  rules:
    - name: check-registry
      match:
        any:
        - resources:
            kinds:
              - Pod
            namespaces:
              - apps
      context:
        - name: approvedRegistry
          configMap:
            name: registry-config
            namespace: platform
      validate:
        message: "Container images must start with {{ approvedRegistry.data.registry }}"
        pattern:
          spec:
            containers:
            - image: "{{ approvedRegistry.data.registry }}*"
```

Save this as `pod-trusted-app.yaml`. Its image comes from `registry.internal/`, the shipyard that will be approved:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: trusted-app
  namespace: apps
spec:
  containers:
    - name: app
      image: registry.internal/app:2.0
```

Save this as `pod-untrusted-app.yaml`. Its image comes from Docker Hub:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: untrusted-app
  namespace: apps
spec:
  containers:
    - name: app
      image: docker.io/library/nginx:alpine
```

### Run it with no answer sheet

Check both Pods with no values at all:

```sh
kyverno apply clusterpolicy-check-registry-cm.yaml --resource pod-trusted-app.yaml --resource pod-untrusted-app.yaml
```

```text
Applying 3 policy rule(s) to 2 resource(s)...

pass: 0, fail: 0, warn: 0, error: 2, skip: 0
```

Both results are `error`, not `fail`. The Kyverno CLI could not read the `ConfigMap`, so it could not finish the check for either Pod. That is a different problem from a real violation, and it is worth spotting fast.

## Write the answer sheet

The fix is to give the CLI the value it could not fetch. You can write it in a file, or pass it on the command line.

### Save a values file

A `configMap` context entry fills the variable with the whole object, so the rule reads `approvedRegistry.data.registry`. The values file must use that same dotted path as its key. Save this as `values.yaml`:

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Values
globalValues:
  "approvedRegistry.data.registry": "registry.internal/"
```

`globalValues` apply to every policy and every resource in the run.

### Run it with the values file

Pass the file with `-f` (long form `--values-file`):

```sh
kyverno apply clusterpolicy-check-registry-cm.yaml --resource pod-trusted-app.yaml --resource pod-untrusted-app.yaml -f values.yaml
```

```text
Applying 3 policy rule(s) to 2 resource(s)...
policy check-registry-cm -> resource apps/Pod/untrusted-app failed:
1 - check-registry validation error: Container images must start with registry.internal/. rule check-registry failed at path /spec/containers/0/image/


pass: 1, fail: 1, warn: 0, error: 0, skip: 0
```

Now the CLI has an answer for the lookup, so it finishes both checks. `trusted-app` passes and `untrusted-app` fails, with the registry from your answer sheet in the message.

A values file can also give a value to one policy and one resource only, under `policies:`, then the policy `name`, then `resources:` with a resource `name` and its `values:`. Use that when different resources need different answers.

### Pass one value inline with `--set`

For a single quick value, skip the file and use `--set`:

```sh
kyverno apply clusterpolicy-check-registry-cm.yaml --resource pod-trusted-app.yaml --resource pod-untrusted-app.yaml --set approvedRegistry.data.registry=registry.internal/
```

The output is the same as with the values file: `pass: 1, fail: 1, warn: 0, error: 0, skip: 0`.

## What a values file cannot do

`-f` and `--set` only answer a variable the rule already gets from a known source, such as a `context` entry. They cannot invent a new variable name.

If you take the `context` block out of this policy and use `{{ someName }}` instead, `--set someName=registry.internal/` does not help. The 1.13.2 CLI skips the policy, prints `Policies Skipped (as required variables are not provided by the user)` and counts an `error`. A live cluster rejects such a policy when you try to apply it.

There is one more catch. If the `context` entry computes its own value (a `variable` entry, not a `configMap` or `apiCall` lookup), the computed value wins over anything you pass with `-f` or `--set`. The answer sheet only wins for lookups that would otherwise need real outside data.

## Common pitfalls

> [!WARNING]
> - **Treating `error` as a failing resource.** An `error` with a `context` lookup offline usually means a missing answer sheet, not a bad Pod.
> - **Using the bare context name as the key.** A `configMap` lookup fills `approvedRegistry` with the whole object. The key must be the full path the rule reads, `approvedRegistry.data.registry`.
> - **Trying to invent a variable.** `-f` and `--set` only answer variables from a known source. An undeclared name is still an error.
> - **Expecting a mock to beat a computed `variable`.** A `variable` context entry computes its own value, and that value wins.
