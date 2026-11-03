---
estimated_duration: 30m
---

# kyverno jp Capstone Lab

Status: UNTESTED - written and statically checked only; not yet run with astrona test.

Welcome to the section capstone, astronaut. A single file in `~/jp-capstone/` holds a Pod, a required label selector and a minimum version, the kind of data a real policy's `preconditions` or `context` block checks. Your job is to combine stock JMESPath with Kyverno's `split`, `semver_compare`, `label_match` and `regex_match`, reading each function's manual with `kyverno jp function` before you trust it.

## Launching the Lab

Run this command to start the cluster:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-040/capstone/labs/lab-01
```

When you think you have finished, send it for grading:

```bash
astrona submit -c sections/section-040/capstone/labs/lab-01
```

When you are done, remove the lab:

```bash
astrona destroy ats-009-lab-008
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-tag.sh` | `tag.txt` holds `2.3.1`, made with `split` |
| `validate-version-check.sh` | `version-check.txt` holds the raw `semver_compare` result |
| `validate-selector-match.sh` | `selector-match.txt` holds the `label_match` result |
| `validate-owner-valid.sh` | `owner-valid.txt` holds the `regex_match` result |

Each script reads the `# expression` line in the answer file, runs it again against `~/jp-capstone/context.json` and compares the result. Every check fails on the untouched starting state, because the `answers/` folder starts empty. `solution/apply.sh` writes the reference answers and is used only by `astrona test`.
