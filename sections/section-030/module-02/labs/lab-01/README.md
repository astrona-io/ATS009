---
estimated_duration: 25m
---

# Mutate And Generate Test Lab

Status: UNTESTED - written and statically checked only; not yet run with astrona test.

Welcome to your mission, astronaut. The folder `~/kyverno-cli-lab` holds a mutate policy, a generate policy and the resources they act on. There is no test manifest. You write the expected files and one `kyverno-test.yaml` that proves three cases: a mutate pass, a mutate skip and a generated resource.

## Launching the Lab

Run this command to start the cluster:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-030/module-02/labs/lab-01
```

When you think you have finished, send it for grading:

```bash
astrona submit -c sections/section-030/module-02/labs/lab-01
```

When you are done, remove the lab:

```bash
astrona destroy ats-009-lab-012
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-manifest-covers-all.sh` | The manifest names both policies and all three resources, and uses `patchedResources`, `generatedResource` and `skip` |
| `validate-suite-passes.sh` | `kyverno test .` exits `0` and at least three tests passed |
| `validate-patched-claim-is-real.sh` | In a scratch copy where the rule paints another label value, the suite fails |
| `validate-generated-claim-is-real.sh` | In a scratch copy where the rule builds an `Egress` policy, the suite fails |
| `validate-skip-claim-is-real.sh` | In a scratch copy where `batch-pod` matches the rule, the suite fails |
