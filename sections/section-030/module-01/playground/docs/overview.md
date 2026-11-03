# Overview: Writing & Running Kyverno Test Suites (Playground)

This is a playground, not a lab. It gives you a terminal with the `kyverno` CLI and a folder of practice files, and then waits. There is no task, no `astrona submit` and no pass or fail. Write test manifests, break them on purpose, and read what the run tells you.

## What is in the box

- The `kyverno` CLI, version `1.13.2`, in `/usr/local/bin`. No cluster is needed: `kyverno test` works on files.
- The folder `~/kyverno-cli-lab` with these files:

  | File | What it is |
  | --- | --- |
  | `require-run-as-nonroot.yaml` | `ClusterPolicy` with rule `check-runAsNonRoot` |
  | `good-pod.yaml` | A Pod that sets `runAsNonRoot: true` |
  | `bad-pod.yaml` | A Pod with no `securityContext` |
  | `web-deployment.yaml` | A Deployment named `web` |
  | `no-privileged.yaml` | `ClusterPolicy` with a `foreach` and `deny` rule `check-privileged` |
  | `privileged-pod.yaml` | A Pod with a privileged container |
  | `calm-pod.yaml` | A Pod with no privileged container |

- There is no `kyverno-test.yaml`. You write it.

## Practice tasks

- Write a `kyverno-test.yaml` for `require-run-as-nonroot` with one entry for `good-pod` and one for `bad-pod`. Run `kyverno test .`.
- Flip one claim, read the `Want ... got ...` reason, and flip it back.
- Put both Pods in one entry with `result: pass` and read the failure.
- Test the `web` Deployment against `require-run-as-nonroot`. Find out which rule name the result needs.
- Write a suite for `no-privileged` with `privileged-pod` and `calm-pod`.
- Run an empty folder (`mkdir empty && kyverno test empty`) and check the exit code with `echo $?`.
- Narrow a run with `--test-case-selector` and add `--detailed-results`.
