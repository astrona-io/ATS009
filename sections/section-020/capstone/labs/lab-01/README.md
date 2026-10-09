---
estimated_duration: 35m
---

# kyverno apply Capstone Lab

Welcome to the section capstone, astronaut. This rule asks mission control which shipyard is approved before it inspects a ship. Offline there is nobody to ask, so you hand the scanner a prepared answer sheet (a values file). Then you switch the rule on, watch the live inspector read the real `ConfigMap` by itself, and finish with a `--cluster --policy-report` audit of the planet.

## Launching the Lab

Run this command to start the cluster:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-020/capstone/labs/lab-01
```

When you think you have finished, send it for grading:

```bash
astrona submit -c sections/section-020/capstone/labs/lab-01
```

When you are done, remove the lab:

```bash
astrona destroy ats-009-lab-004
```
