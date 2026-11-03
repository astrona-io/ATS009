---
estimated_duration: 25m
---

# Mutate And Generate With apply Lab

Status: UNTESTED - written and statically checked only; not yet run with astrona test.

Welcome to your mission, astronaut. A repair crew rule waits on disk that paints a missing `tier` marking on a ship's hull, a base-building rule that drops a welcome crate on every new planet, and a rule that only bridge officers may pass. You will run all three with `kyverno apply`, save what they produce, and send the repaired ship to the cluster.

## Launching the Lab

Run this command to start the cluster:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-020/module-02/labs/lab-01
```

When you think you have finished, send it for grading:

```bash
astrona submit -c sections/section-020/module-02/labs/lab-01
```

When you are done, remove the lab:

```bash
astrona destroy ats-009-lab-010
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-mutated-output.sh` | `scout-mutated.yaml` holds the patched Pod, keeps `app: scout`, and `scout.yaml` is unchanged |
| `validate-generated-output.sh` | `welcome-generated.yaml` holds the ConfigMap `welcome` for the namespace `venus` |
| `validate-user-info.sh` | A user info file makes `bridge-access` pass (exit 0) while the policy still fails without it |
| `validate-live-pod.sh` | Pod `scout` runs in `apps` with `tier=standard` |
