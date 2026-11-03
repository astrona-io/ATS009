---
estimated_duration: 30m
---

# Variables, Exceptions And Suites Lab

Status: UNTESTED - written and statically checked only; not yet run with astrona test.

Welcome to your mission, astronaut. The folder `~/kyverno-cli-lab` holds two policies, an exception, four Pods, a values file and two user info files, sorted into shared folders. There are no test manifests. You write three of them in three folders under `tests/`, so that one `kyverno test .` runs them all.

## Launching the Lab

Run this command to start the cluster:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-030/module-03/labs/lab-01
```

When you think you have finished, send it for grading:

```bash
astrona submit -c sections/section-030/module-03/labs/lab-01
```

When you are done, remove the lab:

```bash
astrona destroy ats-009-lab-013
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-suites-found.sh` | At least three `kyverno-test.yaml` files under `tests/`, using `variables`, `userinfo` and `exceptions` |
| `validate-suite-passes.sh` | `kyverno test .` exits `0` and at least five tests passed |
| `validate-variables-are-used.sh` | In a scratch copy with another approved registry, the suite fails |
| `validate-userinfo-is-used.sh` | In a scratch copy where the admin badge loses `cluster-admin`, the suite fails |
| `validate-exception-is-used.sh` | In a scratch copy where the exception covers another Pod, the suite fails |
| `validate-failing-claims-are-real.sh` | In a scratch copy where `bad-registry-pod` is repaired, the suite fails |
