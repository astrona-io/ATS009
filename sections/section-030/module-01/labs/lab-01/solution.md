# Solution Walkthrough

Follow these steps to diagnose and fix the test manifest:

---

## Step 1: Run the Broken Test Suite

```sh
cd ~/kyverno-cli-lab
kyverno test .
```

The declared expectation says both `good-pod` and `bad-pod` should `pass`. Kyverno actually evaluates them differently:

*   `good-pod` sets `spec.securityContext.runAsNonRoot: true` → it genuinely satisfies the policy's `pattern` → **pass**.
*   `bad-pod` has no `securityContext` block at all → the pattern match fails → **fail**.

The test run reports a mismatch on `bad-pod`, because the manifest claims `pass` but Kyverno actually computes `fail`.

---

## Step 2: Fix the Test Manifest

Split the single two-resource `results` entry into two entries, one per resource, each with its own correct `result`:

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

A single `results` entry can list several resource names under `resources:` only when every one of them shares the exact same expected outcome — `good-pod` and `bad-pod` don't, so they need separate entries.

---

## Step 3: Re-run and Confirm

```sh
kyverno test . --require-tests
echo $?
```

Both cases now report correctly, and the command exits `0`. `--require-tests` additionally fails the run if no test cases were discovered at all, guarding against a manifest that was emptied out rather than fixed.

> [!TIP]
> This is the entire point of `kyverno test`: it doesn't grade "did the resource pass," it grades "does the manifest's *claim* about the outcome match Kyverno's *real* computed outcome." Deleting the inconvenient case, or asserting whatever value happens to make the run green, defeats the purpose — the suite exists to catch exactly that kind of false confidence before it ships to a live cluster.
