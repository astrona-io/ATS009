---
estimated_duration: 20m
---

# kyverno jp Query Lab

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
