---
estimated_duration: 20m
---

# kyverno jp Query Lab

Status: UNTESTED - written and statically checked only; not yet run with astrona test.

Welcome to your mission, astronaut. A Pod file sits in `~/jp-lab/`, and the navigation computer, `kyverno jp query`, is ready on your console. Your job is to pull out single values, clean them with Kyverno's own string functions, and test an image against a wildcard pattern, exactly the way a policy's `context`, `preconditions` or `foreach` block would, and save every answer to a file.

## Launching the Lab

Run this command to start the cluster:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-040/module-01/labs/lab-01
```

When you think you have finished, send it for grading:

```bash
astrona submit -c sections/section-040/module-01/labs/lab-01
```

When you are done, remove the lab:

```bash
astrona destroy ats-009-lab-007
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-name.sh` | `name.txt` holds the Pod name |
| `validate-namespace.sh` | `namespace.txt` holds `checkout`, made with `trim` |
| `validate-environment.sh` | `environment.txt` holds `production`, made with `to_lower` |
| `validate-web-image.sh` | `web-image.txt` holds the image of the first container |
| `validate-pattern-check.sh` | `pattern-check.txt` holds `true`, made with `pattern_match` |

Each script reads the `# expression` line in the answer file, runs it again against `~/jp-lab/pod.json` and compares the result. Every check fails on the untouched starting state, because the `answers/` folder starts empty. `solution/apply.sh` writes the reference answers and is used only by `astrona test`.
