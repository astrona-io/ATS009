---
estimated_duration: 30m
---

# Advanced JMESPath Lab

Status: UNTESTED - written and statically checked only; not yet run with astrona test.

Welcome to your mission, astronaut. Three files sit in `~/jp-lab/`: a fleet of Pods, an admission request and a settings file. Your job is to pick, count and sort Pod data, open a token and a limit with Kyverno's functions, and measure a start time, and to save every answer to a file.

## Launching the Lab

Run this command to start the cluster:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-040/module-02/labs/lab-01
```

When you think you have finished, send it for grading:

```bash
astrona submit -c sections/section-040/module-02/labs/lab-01
```

When you are done, remove the lab:

```bash
astrona destroy ats-009-lab-014
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-busiest-pod.sh` | `busiest-pod.txt` holds the Pod with the most restarts, made with `max_by` |
| `validate-running-count.sh` | `running-count.txt` holds `2`, made with `length` |
| `validate-label-keys.sh` | `label-keys.txt` holds the sorted label keys, made with `sort` |
| `validate-token.sh` | `token.txt` holds the decoded token, made with `base64_decode` |
| `validate-memory.sh` | `memory.txt` holds `512Mi`, made with `multiply` |
| `validate-uptime.sh` | `uptime.txt` holds `2h30m0s`, made with `time_since` |

Each script reads the `# expression` line in the answer file, runs it again against the matching file in `~/jp-lab/` and compares the result. Every check fails on the untouched starting state, because the `answers/` folder starts empty. `solution/apply.sh` writes the reference answers and is used only by `astrona test`.
