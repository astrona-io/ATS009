# Solution Walkthrough

Five queries, one answer file each, then a final look at all five files. Every query uses `-u`, so strings land in the files without quotes.

---

## Step 1: Query the Pod's name

Dot notation walks straight into `metadata.name`:

```sh
kyverno jp query -i ~/jp-lab/pod.json -u 'metadata.name' > ~/jp-lab/answers/name.txt
```

`-u` strips the double quotes a string result would otherwise get, which is what you want in a plain-text answer file.

---

## Step 2: Trim the padded namespace

`trim` is one of Kyverno's custom string functions. Check its signature first:

```sh
kyverno jp function trim
```

```text
Name: trim
  Signature: trim(string, string) string
  Note:      trims both ends of the source string by characters appearing in the second string
```

It takes two arguments: the text, and the characters to cut from both ends. Here that is a single space:

```sh
kyverno jp query -i ~/jp-lab/pod.json -u "trim(metadata.namespace, ' ')" > ~/jp-lab/answers/namespace.txt
```

This turns `"  checkout  "` into `checkout`. With only one argument, `trim(metadata.namespace)` fails with `Error: error evaluating JMESPath expression: incorrect number of args`.

---

## Step 3: Lower-case the environment label

`to_lower`, and its partner `to_upper`, are custom string functions too:

```sh
kyverno jp query -i ~/jp-lab/pod.json -u 'to_lower(metadata.labels.environment)' > ~/jp-lab/answers/environment.txt
```

This converts `PRODUCTION` to `production`.

---

## Step 4: Extract the first container's image

`[0]` picks one item from the `containers` list. No projection here, because you want exactly one value back, not a list:

```sh
kyverno jp query -i ~/jp-lab/pod.json -u 'spec.containers[0].image' > ~/jp-lab/answers/web-image.txt
```

---

## Step 5: Check the image against a wildcard pattern

First, read the function's manual:

```sh
kyverno jp function pattern_match
```

```text
Name: pattern_match
  Signature: pattern_match(string, string|number) bool
  Note:      '*' matches zero or more alphanumeric characters, '?' matches a single alphanumeric character
```

It is a simple wildcard match, not a regular expression, and the pattern comes first. Write the pattern as a raw string in single quotes, not in backticks:

```sh
kyverno jp query -i ~/jp-lab/pod.json -u "pattern_match('registry.example.com/checkout/*', spec.containers[0].image)" > ~/jp-lab/answers/pattern-check.txt
```

The first container's image, `registry.example.com/checkout/web:1.4.2`, fits the pattern, so the answer is `true`.

---

## Verify

Print all five answer files:

```sh
cat ~/jp-lab/answers/name.txt ~/jp-lab/answers/namespace.txt ~/jp-lab/answers/environment.txt ~/jp-lab/answers/web-image.txt ~/jp-lab/answers/pattern-check.txt
```

```text
# metadata.name
checkout-web-7f8c9
# trim(metadata.namespace, ' ')
checkout
# to_lower(metadata.labels.environment)
production
# spec.containers[0].image
registry.example.com/checkout/web:1.4.2
# pattern_match('registry.example.com/checkout/*', spec.containers[0].image)
true
```

Every answer is right. Notice that each file holds two lines: `kyverno jp query` prints the expression as a `#` comment line before the result, on the same output, so the redirect saves both. The grader compares each file with the bare value, and in its current form it does not allow for that comment line, so a correct answer can be marked wrong. If that happens, please report it to the course maintainers.

---

## Submit

Send the mission for grading:

```sh
astrona submit -c sections/section-040/module-01/labs/lab-01
```
