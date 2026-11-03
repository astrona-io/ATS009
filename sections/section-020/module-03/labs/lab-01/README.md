---
estimated_duration: 25m
---

# Exceptions, Warnings And Exit Codes Lab

Status: UNTESTED - written and statically checked only; not yet run with astrona test.

Welcome to your mission, astronaut. A pipeline gate guards the dock: one rule turns ships away, one rule only warns. The old ship `legacy-app` has no `team` marking, and the gate keeps stopping it. You will give it a written exception, make the warning rule report with your own exit code, and keep a results table for the crew.

## Launching the Lab

Run this command to start the cluster:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-020/module-03/labs/lab-01
```

When you think you have finished, send it for grading:

```bash
astrona submit -c sections/section-020/module-03/labs/lab-01
```

When you are done, remove the lab:

```bash
astrona destroy ats-009-lab-011
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-exception.sh` | A `PolicyException` for `legacy-app` makes the Enforce policy exit 0, and the policy still fails without it |
| `validate-gate-exit-code.sh` | `gate-exit-code.txt` holds `3`, and the Audit run with `--audit-warn --warn-exit-code 3` really exits 3 |
| `validate-gate-table.sh` | `gate-table.txt` shows `legacy-app` as Warn and `compliant-app` as Pass |
