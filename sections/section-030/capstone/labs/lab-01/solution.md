# Solution Walkthrough

Three steps: work out every real verdict, write the claims down grouped by shared verdict, then let `kyverno test` confirm them.

---

## Step 1: Work out each rule and Pod result

Read each Pod's `securityContext` and image, then decide each rule:

| Resource | `securityContext.runAsNonRoot` | image | `check-runAsNonRoot` | `require-image-tag` | `validate-image-tag` |
| --- | --- | --- | --- | --- | --- |
| `good-pod` | `true` | `nginx:1.25-alpine` | pass | pass | pass |
| `bad-nonroot-pod` | *(absent)* | `nginx:1.25-alpine` | **fail** | pass | pass |
| `bad-image-pod` | `true` | `nginx:latest` | pass | pass | **fail** |
| `bad-both-pod` | *(absent)* | `nginx:latest` | **fail** | pass | **fail** |

`require-image-tag` passes for all four. Every Pod here has *some* tag, even the ones that fail `validate-image-tag` because that tag is `:latest`.

Check any row with `kyverno apply`. For example, for the Pod that breaks both rules:

```sh
cd ~/kyverno-cli-lab
kyverno apply require-run-as-nonroot.yaml disallow-latest-tag.yaml -r bad-both-pod.yaml -t
```

```text
Applying 9 policy rule(s) to 1 resource(s)...
│────│────────────────────────│────────────────────│──────────────────────────│────────│────────│
│ ID │ POLICY                 │ RULE               │ RESOURCE                 │ RESULT │ REASON │
│────│────────────────────────│────────────────────│──────────────────────────│────────│────────│
│ 1  │ require-run-as-nonroot │ check-runAsNonRoot │ default/Pod/bad-both-pod │ Fail   │        │
│ 2  │ disallow-latest-tag    │ require-image-tag  │ default/Pod/bad-both-pod │ Pass   │        │
│ 3  │ disallow-latest-tag    │ validate-image-tag │ default/Pod/bad-both-pod │ Fail   │        │
│────│────────────────────────│────────────────────│──────────────────────────│────────│────────│
```

The three real verdicts match the last row of the table. (The "9 policy rule(s)" are the three rules plus Kyverno's automatic copies for Deployments and CronJobs.)

---

## Step 2: Write the test manifest

Group by rule, then by shared verdict. Save this as `kyverno-test.yaml` in `~/kyverno-cli-lab`:

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: capstone-tests
policies:
  - require-run-as-nonroot.yaml
  - disallow-latest-tag.yaml
resources:
  - good-pod.yaml
  - bad-nonroot-pod.yaml
  - bad-image-pod.yaml
  - bad-both-pod.yaml
results:
  - policy: require-run-as-nonroot
    rule: check-runAsNonRoot
    resources:
      - good-pod
      - bad-image-pod
    kind: Pod
    result: pass
  - policy: require-run-as-nonroot
    rule: check-runAsNonRoot
    resources:
      - bad-nonroot-pod
      - bad-both-pod
    kind: Pod
    result: fail
  - policy: disallow-latest-tag
    rule: require-image-tag
    resources:
      - good-pod
      - bad-nonroot-pod
      - bad-image-pod
      - bad-both-pod
    kind: Pod
    result: pass
  - policy: disallow-latest-tag
    rule: validate-image-tag
    resources:
      - good-pod
      - bad-nonroot-pod
    kind: Pod
    result: pass
  - policy: disallow-latest-tag
    rule: validate-image-tag
    resources:
      - bad-image-pod
      - bad-both-pod
    kind: Pod
    result: fail
```

Five entries cover all twelve rule and Pod combinations, because grouping folds every case that shares a verdict for a rule into one line.

---

## Step 3: Confirm

Run the suite and print the exit code:

```sh
kyverno test .
echo $?
```

```text
Loading test  ( kyverno-test.yaml ) ...
  Loading values/variables ...
  Loading policies ...
  Loading resources ...
  Loading exceptions ...
  Applying 2 policies to 4 resources ...
  Checking results ...

│──────────│────────────────────────│────────────────────│─────────────────────│────────│────────│
│ ID (12)  │ POLICY                 │ RULE               │ RESOURCE            │ RESULT │ REASON │
│──────────│────────────────────────│────────────────────│─────────────────────│────────│────────│
│ 1        │ require-run-as-nonroot │ check-runAsNonRoot │ Pod/good-pod        │ Pass   │ Ok     │
│ 2        │ require-run-as-nonroot │ check-runAsNonRoot │ Pod/bad-image-pod   │ Pass   │ Ok     │
│ 3        │ require-run-as-nonroot │ check-runAsNonRoot │ Pod/bad-nonroot-pod │ Pass   │ Ok     │
│ 4        │ require-run-as-nonroot │ check-runAsNonRoot │ Pod/bad-both-pod    │ Pass   │ Ok     │
│ 5        │ disallow-latest-tag    │ require-image-tag  │ Pod/good-pod        │ Pass   │ Ok     │
│ 6        │ disallow-latest-tag    │ require-image-tag  │ Pod/bad-nonroot-pod │ Pass   │ Ok     │
│ 7        │ disallow-latest-tag    │ require-image-tag  │ Pod/bad-image-pod   │ Pass   │ Ok     │
│ 8        │ disallow-latest-tag    │ require-image-tag  │ Pod/bad-both-pod    │ Pass   │ Ok     │
│ 9        │ disallow-latest-tag    │ validate-image-tag │ Pod/good-pod        │ Pass   │ Ok     │
│ 10       │ disallow-latest-tag    │ validate-image-tag │ Pod/bad-nonroot-pod │ Pass   │ Ok     │
│ 11       │ disallow-latest-tag    │ validate-image-tag │ Pod/bad-image-pod   │ Pass   │ Ok     │
│ 12       │ disallow-latest-tag    │ validate-image-tag │ Pod/bad-both-pod    │ Pass   │ Ok     │
│──────────│────────────────────────│────────────────────│─────────────────────│────────│────────│


Test Summary: 12 tests passed and 0 tests failed

0
```

All twelve claims match, and the exit code is `0`. Notice that `require-image-tag` needed only one entry naming all four Pods: it is the one rule here where every Pod gets the same real verdict.

The task and the grader also run `kyverno test . --require-tests`, which fails a run with no test cases. The `1.13.2` CLI installed in this lab does not have that flag yet and answers `Error: unknown flag: --require-tests`. If you see that error, your manifest is still correct when `kyverno test .` passes as above; please report it to the course maintainers, because the grader uses this command.

---

## Submit

Send the mission for grading:

```sh
astrona submit -c sections/section-030/capstone/labs/lab-01
```
