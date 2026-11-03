# Testing Mutate Rules

Astronaut, a mutate rule is a repair crew. A ship arrives, the crew paints a marking on the hull, and the ship goes on. To test the crew, you need two things: the ship as it arrives, and a picture of the ship as it must leave. `kyverno test` runs the crew on your file and compares the result with your picture.

You work in `~/kyverno-cli-lab`.

## Meet the policy and two Pods

Look at the policy and the two Pods first:

<!-- astrona:playground:renew -->

```sh
cd ~/kyverno-cli-lab
cat add-managed-by.yaml
cat web-pod.yaml batch-pod.yaml
```

The rule `set-managed-by` matches Pods that carry the label `tier: web`. For those it adds the label `managed-by: kyverno`. `web-pod` has the label `tier: web`, so the crew works on it. `batch-pod` has `tier: batch`, so the crew leaves it alone.

## Write the expected ship

The expected result is a complete resource, the way the Pod must look after the rule ran. Save this as `web-pod-patched.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
  labels:
    tier: web
    managed-by: kyverno
spec:
  containers:
    - name: app
      image: nginx:1.25-alpine
```

It is `web-pod.yaml` with one more label. Write the whole resource, not only the new label: the run compares the full resource.

## Write the checklist line

Save this as `mutate-test.yaml`:

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: mutate-tests
policies:
  - add-managed-by.yaml
resources:
  - web-pod.yaml
  - batch-pod.yaml
results:
  - policy: add-managed-by
    rule: set-managed-by
    resources:
      - web-pod
    kind: Pod
    patchedResources: web-pod-patched.yaml
    result: pass
  - policy: add-managed-by
    rule: set-managed-by
    resources:
      - batch-pod
    kind: Pod
    result: skip
```

Two new things are in this file:

- `patchedResources` points to the expected file. The claim is now: "the rule runs on `web-pod`, and the result is exactly this resource". The `result` is `pass`, because the rule did its work.
- `result: skip` for `batch-pod` says the rule does not apply to that Pod at all. A skip is a claim too: it fails if the Pod suddenly matches.

Run it. The flag `-f` picks the manifest by its file name:

```sh
kyverno test . -f mutate-test.yaml
```

The table has one row for each Pod, both with the result `Pass`. The exit code is `0`. The row for `batch-pod` is `Pass` because the claim `skip` matched what the rule really did.

## Break the picture on purpose

Change the expected file so it no longer matches. For example, in `web-pod-patched.yaml`, change `managed-by: kyverno` to `managed-by: someone`. Run the same command again.

The row for `web-pod` now shows `Fail`, and the reason is `Resource diff`. The exit code is not `0`. The words `Resource diff` mean: the rule ran, but the resource it produced is not the one in your file.

When you see a `Resource diff`, ask which side is wrong:

- If the policy changed on purpose, update the expected file.
- If the expected file was a typo, fix the file.
- If nobody meant to change the output, the policy is wrong. Fix the policy.

Change the value back to `kyverno` before you go on.

## Break the skip on purpose

Open `batch-pod.yaml` and change its label to `tier: web`. Run the test again. The rule now matches the Pod and changes it, so the claim `skip` is false, and the row for `batch-pod` fails. Change the label back to `tier: batch`.

This is why a `skip` entry is worth writing. It proves that the `match` and its selector still keep the rule away from the ships it must not touch.

## Common pitfalls

> [!WARNING]
> - **Writing only the changed lines in the expected file.** `patchedResources` holds the whole resource. A file with only `labels` does not match.
> - **Forgetting the name and the kind.** The expected resource needs the same `apiVersion`, `kind` and `metadata.name` as the input, or the comparison fails.
> - **Writing `result: pass` for a resource the rule does not touch.** If the rule does not match the resource, the right claim is `skip`.
> - **Fixing the expected file without reading the diff.** A `Resource diff` can mean the policy broke. Decide which side is wrong first.
