# Solution Walkthrough

Three steps: run the lying checklist, fix the claim, then run it again. The point is to change the claim to match reality, not to change reality to match the claim.

---

## Step 1: Run the broken test suite

Move into the lab folder and run the suite:

```sh
cd ~/kyverno-cli-lab
kyverno test .
```

```text
Loading test  ( kyverno-test.yaml ) ...
  Loading values/variables ...
  Loading policies ...
  Loading resources ...
  Loading exceptions ...
  Applying 1 policy to 2 resources ...
  Checking results ...

│────│────────────────────────│────────────────────│──────────────│────────│─────────────────────│
│ ID │ POLICY                 │ RULE               │ RESOURCE     │ RESULT │ REASON              │
│────│────────────────────────│────────────────────│──────────────│────────│─────────────────────│
│ 1  │ require-run-as-nonroot │ check-runAsNonRoot │ Pod/good-pod │ Pass   │ Ok                  │
│ 2  │ require-run-as-nonroot │ check-runAsNonRoot │ Pod/bad-pod  │ Fail   │ Want pass, got fail │
│────│────────────────────────│────────────────────│──────────────│────────│─────────────────────│


Test Summary: 1 tests passed and 1 tests failed

Aggregated Failed Test Cases : 
│────│────────────────────────│────────────────────│─────────────│────────│─────────────────────│
│ ID │ POLICY                 │ RULE               │ RESOURCE    │ RESULT │ REASON              │
│────│────────────────────────│────────────────────│─────────────│────────│─────────────────────│
│ 1  │ require-run-as-nonroot │ check-runAsNonRoot │ Pod/bad-pod │ Fail   │ Want pass, got fail │
│────│────────────────────────│────────────────────│─────────────│────────│─────────────────────│
Error: 1 tests failed
```

The manifest claims `pass` for both Pods. The Kyverno engine decides differently:

*   `good-pod` sets `spec.securityContext.runAsNonRoot: true`, so it fits the policy's `pattern`: **pass**. The claim matches, so its test row shows `Pass`.
*   `bad-pod` has no `securityContext` block at all, so the pattern does not fit: **fail**. The claim says `pass`, so the reason reads `Want pass, got fail`.

---

## Step 2: Fix the test manifest

Split the single two-Pod entry into two entries, one per Pod, each with its real verdict. Save this as `kyverno-test.yaml`, replacing the old file:

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: policy-tests
policies:
  - require-run-as-nonroot.yaml
resources:
  - good-pod.yaml
  - bad-pod.yaml
results:
  - policy: require-run-as-nonroot
    rule: check-runAsNonRoot
    resources:
      - good-pod
    kind: Pod
    result: pass
  - policy: require-run-as-nonroot
    rule: check-runAsNonRoot
    resources:
      - bad-pod
    kind: Pod
    result: fail
```

A `results` entry may list several resource names only when every one of them really gets the same verdict. `good-pod` and `bad-pod` do not, so they need separate entries.

---

## Step 3: Re-run and confirm

Run the suite again and print the exit code:

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
  Applying 1 policy to 2 resources ...
  Checking results ...

│────│────────────────────────│────────────────────│──────────────│────────│────────│
│ ID │ POLICY                 │ RULE               │ RESOURCE     │ RESULT │ REASON │
│────│────────────────────────│────────────────────│──────────────│────────│────────│
│ 1  │ require-run-as-nonroot │ check-runAsNonRoot │ Pod/good-pod │ Pass   │ Ok     │
│ 2  │ require-run-as-nonroot │ check-runAsNonRoot │ Pod/bad-pod  │ Pass   │ Ok     │
│────│────────────────────────│────────────────────│──────────────│────────│────────│


Test Summary: 2 tests passed and 0 tests failed

0
```

Both claims now match, and the exit code is `0`. `bad-pod` still really fails the policy; its test row shows `Pass` because the manifest now expects `fail`.

The task and the grader also run the suite with `--require-tests`, a flag that fails a run with no test cases, so a manifest that was emptied instead of fixed cannot pass:

```sh
kyverno test . --require-tests
```

The `1.13.2` CLI installed in this lab does not have that flag yet and answers `Error: unknown flag: --require-tests` with a non-zero exit code. Newer CLIs have it. If you see that error, your manifest is still correct when `kyverno test .` passes as above; please report it to the course maintainers, because the grader uses this command.

> [!TIP]
> `kyverno test` does not grade whether a resource passed. It grades whether the manifest's *claim* about the outcome matches Kyverno's *real* outcome. Deleting the inconvenient case, or writing down whatever makes the run green, defeats the purpose: the suite exists to catch exactly that kind of false confidence before it reaches a live cluster.

---

## Submit

Send the mission for grading:

```sh
astrona submit -c sections/section-030/module-01/labs/lab-01
```
