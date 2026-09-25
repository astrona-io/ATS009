# Solution Walkthrough

Follow these steps to work through each `kyverno jp query` exercise:

---

## Step 1: Query the Pod's name

```sh
kyverno jp query -i ~/jp-lab/pod.json -u 'metadata.name' > ~/jp-lab/answers/name.txt
```
Dot notation walks straight into `metadata.name`. `-u` strips the surrounding `"quotes"` a string result would otherwise get, which is what you want in a plain-text answer file.

---

## Step 2: Trim the whitespace-padded namespace

```sh
kyverno jp query -i ~/jp-lab/pod.json -u 'trim(metadata.namespace)' > ~/jp-lab/answers/namespace.txt
```
`trim` is one of Kyverno's custom string functions — it removes leading/trailing whitespace, turning `"  checkout  "` into `"checkout"`.

---

## Step 3: Lowercase the environment label

```sh
kyverno jp query -i ~/jp-lab/pod.json -u 'to_lower(metadata.labels.environment)' > ~/jp-lab/answers/environment.txt
```
`to_lower` (and its counterpart `to_upper`) is another custom string function — this converts `PRODUCTION` to `production`.

---

## Step 4: Extract the first container's image

```sh
kyverno jp query -i ~/jp-lab/pod.json -u 'spec.containers[0].image' > ~/jp-lab/answers/web-image.txt
```
`[0]` indexes into the `containers` array — no projection here, since you want exactly one value back, not a list.

---

## Step 5: Check the image against a glob pattern

First, confirm the function's exact behavior before using it:
```sh
kyverno jp function pattern_match
```
This is a **non-regex, glob-style** match — `*` is a wildcard, nothing more. Now write the expression, remembering that a string literal argument uses single quotes, not backticks:
```sh
kyverno jp query -i ~/jp-lab/pod.json -u "pattern_match('registry.example.com/checkout/*', spec.containers[0].image)" > ~/jp-lab/answers/pattern-check.txt
```
The first container's image, `registry.example.com/checkout/web:1.4.2`, matches the pattern, so this writes `true` to the file.

---

## Verify

```sh
cat ~/jp-lab/answers/name.txt ~/jp-lab/answers/namespace.txt ~/jp-lab/answers/environment.txt ~/jp-lab/answers/web-image.txt ~/jp-lab/answers/pattern-check.txt
```
Expect:
```text
checkout-web-7f8c9
checkout
production
registry.example.com/checkout/web:1.4.2
true
```
