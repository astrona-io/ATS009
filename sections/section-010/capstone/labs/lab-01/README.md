---
estimated_duration: 25m
---

# Kyverno CLI Installation Capstone Lab

Status: UNTESTED - written and statically checked only; not yet run with astrona test.

Welcome to the section capstone, astronaut. This mission joins everything from the module into one task. You install a pinned version of the Kyverno command-line tool, prove that the crate you downloaded is the genuine one from the shipyard, and turn on bash completion so the console finishes `kyverno` commands for you.

## Launching the Lab

Run this command to start the cluster:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-010/capstone/labs/lab-01
```

When you think you have finished, send it for grading:

```bash
astrona submit -c sections/section-010/capstone/labs/lab-01
```

When you are done, remove the lab:

```bash
astrona destroy ats-009-lab-002
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-binary-official.sh` | The installed `kyverno` is byte for byte the official `v1.13.2` release binary |
| `validate-version-pinned.sh` | `kyverno version` exits cleanly and its `Version:` line shows `1.13.2` |
| `validate-bash-completion.sh` | `/etc/bash_completion.d/kyverno` holds a bash completion script for `kyverno` |

All three fail on the starting state, because no CLI is installed.
