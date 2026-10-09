---
estimated_duration: 25m
---

# Offline & Cluster Policy Apply Lab

Welcome to your mission, astronaut. A rule that requires a `team` label is waiting on disk, and two ships are already docked on the planet `apps`: one with the label and one without. Your job is to test the rule on paper with `kyverno apply`, switch it on in the live cluster, audit the planet with a policy report, and watch the docking inspector turn away a new ship that breaks the rule.

## Launching the Lab

Run this command to start the cluster:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-020/module-01/labs/lab-01
```

When you think you have finished, send it for grading:

```bash
astrona submit -c sections/section-020/module-01/labs/lab-01
```

When you are done, remove the lab:

```bash
astrona destroy ats-009-lab-003
```
