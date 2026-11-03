# Overview: Testing Mutate and Generate Rules (Playground)

This is a playground, not a lab. It gives you a terminal with the `kyverno` CLI and a folder of practice files, and then waits. There is no task, no `astrona submit` and no pass or fail. Write test manifests, break them on purpose, and read what the run tells you.

## What is in the box

- The `kyverno` CLI, version `1.13.2`, in `/usr/local/bin`. No cluster is needed: `kyverno test` works on files.
- The folder `~/kyverno-cli-lab` with these files:

  | File | What it is |
  | --- | --- |
  | `add-managed-by.yaml` | `ClusterPolicy` with mutate rule `set-managed-by`, which paints `managed-by: kyverno` on Pods labelled `tier: web` |
  | `web-pod.yaml` | A Pod labelled `tier: web` |
  | `batch-pod.yaml` | A Pod labelled `tier: batch` |
  | `add-default-deny.yaml` | `ClusterPolicy` with generate rule `create-default-deny`, which builds a `NetworkPolicy` in every new namespace |
  | `team-a-namespace.yaml` | A Namespace named `team-a` |
  | `clone-registry-secret.yaml` | `ClusterPolicy` with generate rule `copy-regcred`, which clones a `Secret` into every new namespace |
  | `team-b-namespace.yaml` | A Namespace named `team-b` |
  | `regcred-source.yaml` | The `Secret` `regcred` in namespace `default`, the source of the clone |

- There is no `kyverno-test.yaml` and there are no expected-output files. You write them.

## Practice tasks

- Write the patched Pod for `web-pod` and a `results` entry with `patchedResources`. Run it with `-f`.
- Change one label in the patched file and read the `Resource diff` reason. Change it back.
- Add `batch-pod` with `result: skip`. Then give it the label `tier: web` and see the claim break.
- Write the `NetworkPolicy` that `team-a` must get and test it with `generatedResource`.
- Change `Ingress` to `Egress` in the expected file and read the failure.
- Test the clone rule with `cloneSourceResource` and `generatedResource`.
