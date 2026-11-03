# Question

Solve this question on: `terminal`

Astronaut, your mission: use the helper buttons of the handheld scanner. The Kyverno command-line interface (CLI) `v1.13.2` is installed in `/usr/local/bin`. The folder `/root/toolbox-lab` holds a policy `policy.yaml` (`ClusterPolicy` `require-team-label`, rule `check-team-label`) and two Pod files in the namespace `apps`: `compliant-app.yaml` (has the label `team: checkout`) and `legacy-app.yaml` (has no `team` label).

Do the following. Work in `/root/toolbox-lab`, and do not edit the three starting files.

1.  Write the command reference of the CLI into the folder `/root/toolbox-lab/reference` with the CLI's own docs command.
2.  Save the zsh completion script for `kyverno` as `/root/toolbox-lab/_kyverno`.
3.  Make `kubectl kyverno version` work, without Krew, by giving the existing binary the plugin name.
4.  With `kyverno create test`, write the test scaffold `/root/toolbox-lab/scaffold-test.yaml`. It lists `policy.yaml` and both Pod files, and it expects the result `pass` for `compliant-app` and the result `fail` for `legacy-app`, both for the rule `check-team-label` of the policy `require-team-label`.
5.  With `kyverno create user-info`, write `/root/toolbox-lab/user-info.yaml` for the user `alice@example.com`, in the group `developers`, with the cluster role `admin`.

The grader runs five checks:

- `/root/toolbox-lab/reference/kyverno_apply.md` and `kyverno_test.md` exist and are not empty.
- `/root/toolbox-lab/_kyverno` is not empty and holds a zsh completion script (a `compdef` line) for `kyverno`.
- An executable named `kubectl-kyverno` is on the `PATH`, and `kubectl kyverno version` runs and reports `1.13.2`.
- `scaffold-test.yaml` mentions the policy file, both Pod files, the policy and the rule, expects `pass` for `compliant-app` and `fail` for `legacy-app`.
- `user-info.yaml` mentions `alice@example.com`, `developers` and `admin`.
