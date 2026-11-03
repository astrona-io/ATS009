---
estimated_duration: 20m
---

# The Kyverno CLI Toolbox Lab

Status: UNTESTED - written and statically checked only; not yet run with astrona test.

Welcome back, astronaut. The scanner `kyverno` `v1.13.2` is installed, and a folder holds a policy and two Pod files. Your job is to use the helper buttons: the command reference, shell completion, the `kubectl` plugin name and the `kyverno create` scaffolds. The task is in `question.md`; the walkthrough is in `solution.md`.

## Launching the Lab

Run this command to start the cluster:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-010/module-02/labs/lab-01
```

When you think you have finished, send it for grading:

```bash
astrona submit -c sections/section-010/module-02/labs/lab-01
```

When you are done, remove the lab:

```bash
astrona destroy ats-009-lab-009
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-reference-docs.sh` | `reference/kyverno_apply.md` and `kyverno_test.md` exist and are not empty |
| `validate-zsh-completion.sh` | `_kyverno` is not empty and has a `compdef` line |
| `validate-kubectl-plugin.sh` | `kubectl-kyverno` is on the `PATH` and `kubectl kyverno version` reports `1.13.2` |
| `validate-test-scaffold.sh` | `scaffold-test.yaml` lists the files and expects pass for `compliant-app`, fail for `legacy-app` |
| `validate-user-info.sh` | `user-info.yaml` names `alice@example.com`, `developers` and `admin` |

All five fail on the starting state, because none of the files exists and the plugin name is missing.
