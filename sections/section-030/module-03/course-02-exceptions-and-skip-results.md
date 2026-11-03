# Exceptions And Skip Results

Astronaut, one old ship in the fleet cannot follow the new rule yet. Mission control signs a waiver for it: "this ship may break this rule for now". In Kyverno, that waiver is a `PolicyException`. Your pre-flight checklist must prove two things: the waiver frees the old ship, and it frees nothing else.

You work in `~/kyverno-cli-lab`.

## Meet the waiver

Look at the waiver and the Pods it is about:

<!-- astrona:playground:renew -->

```sh
cd ~/kyverno-cli-lab
cat policies/legacy-exception.yaml
cat resources/legacy-pod.yaml resources/bad-registry-pod.yaml
```

The `PolicyException` says: for the policy `restrict-registry` and its rule `check-registry`, Pods named `legacy-pod` are excused. `legacy-pod` and `bad-registry-pod` both use an image from the wrong registry, so both would fail the rule. Only `legacy-pod` has a waiver.

## Test the waiver

Save this as `exception-test.yaml`. The `exceptions` list names the waiver file, and the values file is still needed because the rule still reads the registry variable:

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: exception-tests
policies:
  - policies/restrict-registry.yaml
resources:
  - resources/legacy-pod.yaml
  - resources/bad-registry-pod.yaml
exceptions:
  - policies/legacy-exception.yaml
variables: values/registry-values.yaml
results:
  - policy: restrict-registry
    rule: check-registry
    resources:
      - legacy-pod
    kind: Pod
    result: skip
  - policy: restrict-registry
    rule: check-registry
    resources:
      - bad-registry-pod
    kind: Pod
    result: fail
```

Run it:

```sh
kyverno test . -f exception-test.yaml
```

Both rows show `Pass` and the exit code is `0`. The excused Pod is `skip`, and the Pod without a waiver still fails. The second line is as important as the first: it proves the waiver is narrow.

### Take the waiver away

Delete the three lines of the `exceptions` list from the manifest and run again. The row for `legacy-pod` now fails with a reason like `Want skip, got fail`. Without the waiver, the rule applies and the Pod breaks it. Put the list back.

This is the check that matters in practice. If someone deletes or edits the waiver file, a test with the `skip` claim fails, and the change cannot slip through unseen.

## Four reasons for `skip`

A `skip` result means the rule did not judge the resource. It does not say why. Four different causes give the same word:

| Cause | Where it comes from | Example in this module |
| --- | --- | --- |
| The resource does not match the rule | `match` or its selector | a Pod with another label than the rule selects |
| The resource is excluded | `exclude` block | a cluster admin and a `tier: platform` Pod |
| A precondition is false | `preconditions` on the rule | a rule that only applies in one namespace |
| A `PolicyException` covers it | the `exceptions` list | `legacy-pod` |

The test result is the same, so the **claim** must carry the meaning. Name the reason in the resource names and in the file names: `legacy-pod` with an exception file next to it tells the next reader why it is skipped. A suite with many unexplained `skip` entries is hard to trust.

## Common pitfalls

> [!WARNING]
> - **Claiming `skip` without the exception in the manifest.** The `exceptions` list is part of the test. Without it, the rule judges the Pod.
> - **Only testing the excused Pod.** Add a Pod that has no waiver and claim `fail`. Otherwise a waiver that frees everything would pass.
> - **Excusing the wrong rule.** The exception lists `policyName` and `ruleNames`. A rule that is not listed is still checked.
> - **Mixing up the reasons for skip.** The word `skip` is the same for a non-match, an exclude, a precondition and an exception. Say which one you mean in the names.
