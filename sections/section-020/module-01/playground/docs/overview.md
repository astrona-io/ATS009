# Overview: Applying Policies with the Kyverno CLI (Playground)

This is a playground, not a lab. It starts a training solar system (a `kind` cluster) and then waits. There is no task, no `astrona submit` and no pass or fail. Run `kyverno apply` as often as you like, break things, and use `astrona destroy` to start over.

## What is in the box

- A `kind` cluster with the Kyverno controller `v1.13.2` in the namespace `kyverno`. `kubectl` already points at it.
- The `kyverno` CLI `1.13.2` in `/usr/local/bin`. Check it with `kyverno version`.
- The namespace `apps` with two running Pods:

  | Pod | Label |
  | --- | --- |
  | `compliant-app` | `team: checkout` |
  | `legacy-app` | none |

- Example files in `/root/apply-lab/`: `policy.yaml` (the `ClusterPolicy` `require-team-label`, set to `Enforce`), `compliant-app.yaml` and `legacy-app.yaml`.
- The policy is not applied to the cluster. Applying it is your choice.

## Practice ideas

- Check the policy against both Pod files with `--resource`, with and without `--table`. Print the exit code with `echo $?` after each run.
- Put the two Pod files in a folder and point `--resource` at the folder.
- Save a policy that reads a `ConfigMap` in a `context` entry and run it with no values, with a values file and with `--set`.
- Run `kyverno apply /root/apply-lab/policy.yaml --cluster -n apps` and compare it with the offline run. Add `--policy-report` and read the report.
- Apply the policy with `kubectl apply -f /root/apply-lab/policy.yaml`, try to create a Pod without a `team` label, and see which Pod the inspector turns away.
