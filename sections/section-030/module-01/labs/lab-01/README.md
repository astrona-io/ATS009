---
estimated_duration: 20m
---

# Kyverno Test Suite Lab

Welcome to your mission, astronaut. A test manifest in `~/kyverno-cli-lab` claims that two Pods both pass a policy, but one of them really breaks it. Your job is to run the suite, read which claim is wrong, and fix the manifest so it tells the truth about each Pod, without deleting the case that is inconvenient.

## Launching the Lab

Run this command to start the cluster:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-030/module-01/labs/lab-01
```

When you think you have finished, send it for grading:

```bash
astrona submit -c sections/section-030/module-01/labs/lab-01
```

When you are done, remove the lab:

```bash
astrona destroy ats-009-lab-005
```
