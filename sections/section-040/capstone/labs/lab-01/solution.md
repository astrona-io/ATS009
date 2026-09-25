# Solution Walkthrough

Follow these steps to combine JMESPath basics with Kyverno's custom functions, the way a real policy's `preconditions`/`context` block would:

---

## Step 1: Extract the version tag

```sh
kyverno jp query -i ~/jp-capstone/context.json -u "split(pod.spec.containers[0].image, ':')[1]" > ~/jp-capstone/answers/tag.txt
```
`split` is a stock-adjacent string function — it splits `registry.example.com/payments/api:2.3.1` on `:` and `[1]` takes the second element, `2.3.1`.

---

## Step 2: Compare the tag against the minimum version

Check the function's exact behavior first:
```sh
kyverno jp function semver_compare
```
Then compare the extracted tag against `minVersion`:
```sh
kyverno jp query -i ~/jp-capstone/context.json -u "semver_compare(split(pod.spec.containers[0].image, ':')[1], minVersion)" > ~/jp-capstone/answers/version-check.txt
```
Since `2.3.1` is newer than the `2.0.0` floor, expect a result indicating the first version is greater — read the exact convention (positive/negative/zero, or boolean) from `kyverno jp function semver_compare`'s own output rather than assuming.

---

## Step 3: Confirm the label selector matches

Check the function's exact argument order first:
```sh
kyverno jp function label_match
```
Then compare the Pod's labels against the required selector:
```sh
kyverno jp query -i ~/jp-capstone/context.json -u "label_match(requiredSelector, pod.metadata.labels)" > ~/jp-capstone/answers/selector-match.txt
```
`pod.metadata.labels` (`team: payments, tier: backend`) satisfies `requiredSelector` (`team: payments`), so this should confirm a match.

---

## Step 4: Validate the owner annotation looks like an email

```sh
kyverno jp query -i ~/jp-capstone/context.json -u "regex_match('^[^@]+@[^@]+\\.[^@]+\$', pod.metadata.annotations.owner)" > ~/jp-capstone/answers/owner-valid.txt
```
Unlike `pattern_match`, `regex_match` runs a real regular expression — here, a simple "has exactly one `@` with something on both sides and a dot in the domain" shape check against `platform-team@example.com`.

---

## Verify

```sh
cat ~/jp-capstone/answers/tag.txt ~/jp-capstone/answers/version-check.txt ~/jp-capstone/answers/selector-match.txt ~/jp-capstone/answers/owner-valid.txt
```
Expect the version tag, a `semver_compare` result confirming the tag is newer than the floor, and two `true` booleans.
