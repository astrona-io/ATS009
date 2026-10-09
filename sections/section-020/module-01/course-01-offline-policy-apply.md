# Offline Policy Apply

Astronaut, the most important fact about `kyverno apply` is this: in its default mode, **it does not touch a cluster.** You give it a policy file and one or more resource files. The CLI checks the policy's rules against those resources inside its own process, the same way the admission controller's rule engine would. Think of a dry run in the simulator: you inspect ship blueprints on paper, and no real ship docks.

This part shows a real offline run, how to read its result, and why its exit code matters.

## Run your first offline check

The best way to learn the command is to run it once. You need one policy and two resources: one that should pass and one that should fail.

### Save the policy and two Pods

Save this as `clusterpolicy-require-team-label.yaml`. It requires a non-empty `team` label on every Pod in the namespace `apps`:

```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-team-label
spec:
  validationFailureAction: Enforce
  background: true
  rules:
    - name: check-team-label
      match:
        any:
        - resources:
            kinds:
              - Pod
            namespaces:
              - apps
      validate:
        message: "A non-empty 'team' label is required on every Pod in apps."
        pattern:
          metadata:
            labels:
              team: "?*"
```

The `pattern` is the template the ship's papers must fit. `"?*"` means "at least one character", so the label must exist and must not be empty.

Save this as `pod-compliant-app.yaml`. It carries the label, like a marking painted on the hull:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: compliant-app
  namespace: apps
  labels:
    team: checkout
spec:
  containers:
    - name: app
      image: nginx:alpine
```

Save this as `pod-legacy-app.yaml`. It has no `team` label:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: legacy-app
  namespace: apps
spec:
  containers:
    - name: app
      image: nginx:alpine
```

### Check both Pods against the policy

Apply the policy to both files. `--resource` (short form `-r`) takes one file each time you use it:

```sh
kyverno apply clusterpolicy-require-team-label.yaml --resource pod-compliant-app.yaml --resource pod-legacy-app.yaml
```

```text
Applying 3 policy rule(s) to 2 resource(s)...
policy require-team-label -> resource apps/Pod/legacy-app failed:
1 - check-team-label validation error: A non-empty 'team' label is required on every Pod in apps. rule check-team-label failed at path /metadata/labels/


pass: 1, fail: 1, warn: 0, error: 0, skip: 0
```

The Kyverno CLI did the whole check itself, with no cluster. It names the Pod that failed, the rule, the message and the path in the YAML where the template did not fit. The passing Pod, `compliant-app`, is counted in the summary line but not listed.

The policy has one rule, but the CLI says "3 policy rule(s)". Kyverno automatically writes extra copies of a Pod rule for the shipyards that build Pods, such as Deployments and CronJobs. These are called autogen rules. They do not match a bare Pod, so they add nothing to this result.

### See every result in a table

Add `--table` (short form `-t`) to list every resource and its result, passing ones included:

```sh
kyverno apply clusterpolicy-require-team-label.yaml --resource pod-compliant-app.yaml --resource pod-legacy-app.yaml --table
```

```text
Applying 3 policy rule(s) to 2 resource(s)...
│────│────────────────────│──────────────────│────────────────────────│────────│────────│
│ ID │ POLICY             │ RULE             │ RESOURCE               │ RESULT │ REASON │
│────│────────────────────│──────────────────│────────────────────────│────────│────────│
│ 1  │ require-team-label │ check-team-label │ apps/Pod/compliant-app │ Pass   │        │
│ 2  │ require-team-label │ check-team-label │ apps/Pod/legacy-app    │ Fail   │        │
│────│────────────────────│──────────────────│────────────────────────│────────│────────│
```

The table shows both Pods. The table form does not print the summary line, so pick the form you need.

## Point it at more files at once

One file at a time gets slow with many resources. `--resource` also accepts a whole folder, and the policy argument can be a folder of policies too:

```sh
kyverno apply clusterpolicy-require-team-label.yaml --resource=./resources/
kyverno apply ./policies/ --resource=./resources/
```

The CLI then checks every policy in the first folder against every resource in the second.

## Read the summary line

Every default `apply` run ends with one summary line. Each number counts one kind of result:

| Result | What it means |
| --- | --- |
| `pass` | The resource fits the rule: cleared. |
| `fail` | The resource breaks the rule. Under `Enforce`, the live inspector would turn it away. |
| `warn` | The rule matched, but it is set to warn instead of fail (see the `--audit-warn` flag). Cleared with a warning note. |
| `error` | Kyverno could not finish checking the rule at all, for example because of a broken policy or a missing variable. This is not the same as a real `fail`. |
| `skip` | The rule does not apply to this resource, because its `match` or `exclude` block leaves it out. |

## Use the exit code

When a command ends, it leaves an exit code: the green or red light on the console. `0` is green. Anything else is red.

### Check the light

Run the same check again, then print the exit code of the last command:

```sh
kyverno apply clusterpolicy-require-team-label.yaml --resource pod-compliant-app.yaml --resource pod-legacy-app.yaml
echo $?
```

The summary is the same as before, and `echo $?` prints `1`. Any `fail` or `error` makes `kyverno apply` end with a non-zero exit code.

That is what makes `apply` useful as a gate in a CI pipeline (continuous integration, the launch checklist every change must clear). The pipeline sees the red light and stops the change.

> [!TIP]
> A script that runs `kyverno apply` and then carries on with the next command hides every failure. Let the command's exit code decide: run it as its own pipeline step, or join commands with `&&` so a red light stops the chain.

## Common pitfalls

> [!WARNING]
> - **Ignoring the exit code.** `kyverno apply` exits non-zero on any `fail` or `error`. A script that does not check `$?` silently lets real violations through.
> - **Looking for the passing resource in the default output.** Without `--table`, only failing resources are listed. Passing ones show up only as a number in the summary line.
> - **Reading `error` as `fail`.** `error` means the CLI could not finish the check. Fix the policy or supply the missing value; do not "fix" the resource.
> - **Expecting the cluster to change.** Offline `apply` never creates, changes or rejects anything in a cluster. It only reports.
