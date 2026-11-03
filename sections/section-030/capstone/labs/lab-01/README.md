---
estimated_duration: 35m
---

# kyverno test Capstone Lab

Status: UNTESTED - written and statically checked only; not yet run with astrona test.

Welcome to the section capstone, astronaut. Two policies, three rules and four ships are waiting in `~/kyverno-cli-lab`, and nobody has written the checklist yet. Your job is to work out every real verdict, then write a complete `kyverno-test.yaml` from scratch, grouping ships that share a verdict so the checklist stays as short as the truth allows.

## Launching the Lab

Run this command to start the cluster:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-030/capstone/labs/lab-01
```

When you think you have finished, send it for grading:

```bash
astrona submit -c sections/section-030/capstone/labs/lab-01
```

When you are done, remove the lab:

```bash
astrona destroy ats-009-lab-006
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-manifest-covers-all.sh` | The manifest names both policies, all three rules and all four Pods |
| `validate-suite-passes.sh` | `kyverno test .` exits `0` and twelve tests passed |
| `validate-grouped.sh` | At most five `results` entries |
| `validate-nonroot-rule-asserted.sh` | The suite fails when `good-pod` loses `runAsNonRoot` |
| `validate-image-rules-asserted.sh` | The suite fails when `good-pod` uses `:latest` |
| `validate-failing-claims-are-real.sh` | The suite fails when `bad-both-pod` is repaired |
