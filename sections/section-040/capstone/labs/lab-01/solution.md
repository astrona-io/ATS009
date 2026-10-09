# Solution Walkthrough

Four answers, each built the way a careful astronaut builds a policy expression: read the instrument's manual first, then ask the question.

---

## Step 1: Extract the version tag

Read the manual for `split`:

```sh
kyverno jp function split
```

```text
Name: split
  Signature: split(string, string) array[string]
  Note:      splits the first string when the second string is found and converts it into an array 
```

`split` returns a list. Split the image on `:` and pick the second item with `[1]`:

```sh
kyverno jp query -i ~/jp-capstone/context.json -u "split(pod.spec.containers[0].image, ':')[1]" > ~/jp-capstone/answers/tag.txt
```

`registry.example.com/payments/api:2.3.1` splits into `registry.example.com/payments/api` and `2.3.1`, so the answer is `2.3.1`.

---

## Step 2: Compare the tag with the minimum version

Read the manual first:

```sh
kyverno jp function semver_compare
```

```text
Name: semver_compare
  Signature: semver_compare(string, string) bool
  Note:      compares two strings which comply with the semantic versioning schema and outputs a boolean response as to the position of the second relative to the first
```

The result is a boolean. The first argument is the version to check, and the second is a version or a range it must satisfy. Compare the tag from Step 1 with `minVersion`:

```sh
kyverno jp query -i ~/jp-capstone/context.json -u "semver_compare(split(pod.spec.containers[0].image, ':')[1], minVersion)" > ~/jp-capstone/answers/version-check.txt
```

The answer is `false`, even though `2.3.1` is newer than `2.0.0`. `minVersion` holds the bare version `2.0.0`, and a bare version as the second argument means "exactly 2.0.0". A real policy that wants "at least 2.0.0" writes the range `>=2.0.0`; for example `semver_compare('2.3.1', '>=2.0.0')` is `true`. The task asks for the raw result, so `false` is the right answer here.

---

## Step 3: Check the label selector

Check the argument order first:

```sh
kyverno jp function label_match
```

```text
Name: label_match
  Signature: label_match(object, object) bool
  Note:      object arguments must be enclosed in backticks; ex. `{{request.object.spec.template.metadata.labels}}`
```

The selector comes first, and the labels to check come second. Both are objects from the file here, so no backticks are needed:

```sh
kyverno jp query -i ~/jp-capstone/context.json -u "label_match(requiredSelector, pod.metadata.labels)" > ~/jp-capstone/answers/selector-match.txt
```

The Pod's labels (`team: payments`, `tier: backend`) include everything `requiredSelector` asks for (`team: payments`), so the answer is `true`.

---

## Step 4: Check that the owner looks like an email address

Unlike `pattern_match`, `regex_match` runs a full regular expression, and the expression comes first:

```sh
kyverno jp query -i ~/jp-capstone/context.json -u "regex_match('^[^@]+@[^@]+\\.[^@]+\$', pod.metadata.annotations.owner)" > ~/jp-capstone/answers/owner-valid.txt
```

The pattern is a simple shape check: exactly one `@`, something on both sides, and a dot in the part after the `@`. `platform-team@example.com` fits, so the answer is `true`. Inside the double quotes, `\\.` reaches Kyverno as `\.` and `\$` as `$`.

---

## Verify

Print all four answer files:

```sh
cat ~/jp-capstone/answers/tag.txt ~/jp-capstone/answers/version-check.txt ~/jp-capstone/answers/selector-match.txt ~/jp-capstone/answers/owner-valid.txt
```

```text
# split(pod.spec.containers[0].image, ':')[1]
2.3.1
# semver_compare(split(pod.spec.containers[0].image, ':')[1], minVersion)
false
# label_match(requiredSelector, pod.metadata.labels)
true
# regex_match('^[^@]+@[^@]+\.[^@]+$', pod.metadata.annotations.owner)
true
```

The four answers are `2.3.1`, `false`, `true` and `true`. Each file also holds the `#` comment line that `kyverno jp query` prints before every result. The grader in its current form does not allow for that comment line, so a correct answer can be marked wrong. If that happens, please report it to the course maintainers.

---

## Submit

Send the mission for grading:

```sh
astrona submit -c sections/section-040/capstone/labs/lab-01
```
