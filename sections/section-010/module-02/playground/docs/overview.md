# Overview: The Kyverno CLI Toolbox (Playground)

This is a **playground**, not a lab. It starts a training solar system (a `kind` cluster) with the Kyverno CLI installed, and then waits. There is no task, no `astrona submit` and no pass or fail. Explore the commands, break things, `astrona destroy` and start over.

## What is in the box

- A `kind` cluster with the Kyverno controller `v1.13.2` running in the namespace `kyverno`.
- The `kyverno` CLI `v1.13.2` in `/usr/local/bin`. You are the administrator (`root`), and `kubectl` is ready.
- A scratch folder with sample files:

  | Path | What it is |
  | --- | --- |
  | `/root/toolbox/policy.yaml` | `ClusterPolicy` `require-team-label` with the rule `check-team-label` |
  | `/root/toolbox/compliant-app.yaml` | Pod `compliant-app` in `apps`, with the label `team: checkout` |
  | `/root/toolbox/legacy-app.yaml` | Pod `legacy-app` in `apps`, without a `team` label |

## Practice ideas

- Walk the command tree: `kyverno help`, then `kyverno create --help`, then one level deeper.
- Compare `kyverno help` with `KYVERNO_EXPERIMENTAL=true kyverno help` and note what changes.
- Generate the command reference with `kyverno docs -o /root/reference` and list the files it writes.
- Write a completion script for each shell and read its first line.
- Link the binary as `kubectl-kyverno` and call it as `kubectl kyverno version`. Try `kubectl plugin list`.
- Scaffold a test file, a values file and a user-info file with `kyverno create`, read them, and change the flags to see how the output changes.
