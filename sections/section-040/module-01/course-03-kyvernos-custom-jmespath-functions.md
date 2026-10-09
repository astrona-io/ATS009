# Kyverno's Custom JMESPath Functions

Astronaut, stock JMESPath gives you a solid general toolkit: `length`, `contains`, `sort_by`, `to_string` and the rest of the built-in functions. But policy authors need things the language was never designed for: comparing two sets of Kubernetes labels, checking an image version against a range, hashing a string, or testing whether a time falls inside a window. Kyverno adds extra instruments to the navigation computer for exactly these jobs.

These functions exist **only in Kyverno's engine**: in `kyverno jp` and in a live policy. A plain JMESPath tool, or the playground on the JMESPath website, does not know them. This part shows how to read their manual from the CLI, gives a tour of the groups, and works through real examples.

## `kyverno jp function`: your live manual

The CLI carries the manual for its own instruments. Reading it takes seconds and always matches the binary you have.

### Read one function's signature

Look up a function before you use it:

```sh
kyverno jp function truncate
```

```text
Name: truncate
  Signature: truncate(string, number) string
  Note:      length argument must be enclosed in backticks; ex. "{{request.object.metadata.name | truncate(@, `9`)}}"
```

The signature tells you the order and the type of each argument, and what comes back. The note warns you about the most common mistake: the number must be a JSON literal, in backticks.

### List every function

Run the command without a name to list them all:

```sh
kyverno jp function
```

This is the start of the list from the `1.13.2` CLI, shortened to the first three entries:

```text
Name: add
  Signature: add(any, any) any
  Note:      does arithmetic addition of two specified values of numbers, quantities, and durations

Name: base64_decode
  Signature: base64_decode(string) string
  Note:      decodes a base 64 string

Name: base64_encode
  Signature: base64_encode(string) string
  Note:      encodes a regular, plaintext and unencoded string to base64
```

The full list in `1.13.2` has 49 functions.

> [!TIP]
> Argument order, return types and edge cases can change between Kyverno versions. Before you write an expression with a custom function, run `kyverno jp function <name>` on the CLI version you actually use, instead of trusting a half-remembered signature. It is faster than searching documentation, and it is always right for your binary.

## A tour of the groups

The functions fall into a few natural groups. These are the ones you will reach for most often, all present in the `1.13.2` CLI:

| Group | Functions | What they are for |
| --- | --- | --- |
| Strings | `to_upper`, `to_lower`, `trim`, `trim_prefix`, `truncate`, `split`, `replace`, `replace_all` | Shaping text: normalising a label value, trimming a padded field, cutting a tag off an image reference |
| Matching | `pattern_match`, `regex_match`, `compare`, `equal_fold` | Testing a string against a wildcard pattern or a regular expression, or comparing without caring about upper and lower case |
| Kubernetes-aware | `label_match`, `image_normalize` | Checking labels against a label selector, or writing an image reference in its full standard form |
| Encoding and hashing | `base64_encode`, `base64_decode`, `sha256`, `x509_decode` | Encoding and decoding text, hashing a string, reading a certificate |
| Math (unit-aware) | `add`, `subtract`, `multiply`, `divide`, `modulo`, `round` | Arithmetic that understands Kubernetes quantities (`"500m"`, `"2Gi"`) and durations, not just plain numbers |
| Versions | `semver_compare` | Checking a semantic version against a version or a range |
| Time | `time_now`, `time_add`, `time_diff`, `time_since`, `time_before`, `time_after`, `time_between`, `time_parse`, `time_truncate`, `time_to_cron` | Everything from "does this certificate expire soon?" to scheduling logic |
| Structural | `items`, `object_from_lists`, `lookup`, `parse_json`, `parse_yaml` | Reshaping data, for example turning a map into a list of key and value pairs and back |

## Worked examples

Each example below runs against `pod.json`, the cut-down Pod with the image `registry.example.com/checkout/web:1.4.2` in its first container. If you do not have it, save this as `pod.json`:

```json
{
  "metadata": { "name": "checkout-web-7f8c9", "labels": { "team": "checkout" } },
  "spec": {
    "containers": [
      { "name": "web", "image": "registry.example.com/checkout/web:1.4.2" },
      { "name": "sidecar", "image": "registry.example.com/checkout/envoy:1.28.0" }
    ]
  }
}
```

### Clean up text

Lower-case a shouted value before you compare it, then strip stray spaces that a payload sometimes carries:

```sh
kyverno jp query -i pod.json -u "to_lower('PRODUCTION')"
kyverno jp query -i pod.json -u "trim('  checkout  ', ' ')"
```

```text
# to_lower('PRODUCTION')
production
# trim('  checkout  ', ' ')
checkout
```

`trim` takes **two** arguments in Kyverno: the text, and the characters to cut from both ends. Here the second argument is a single space. With only one argument, `trim` fails with `incorrect number of args`.

### Match a wildcard pattern, then a regular expression

Check the first image against a wildcard pattern, then check an email address against a regular expression:

```sh
kyverno jp query -i pod.json -u "pattern_match('registry.example.com/checkout/*', spec.containers[0].image)"
kyverno jp query -i pod.json -u "regex_match('^[^@]+@[^@]+\\.[^@]+$', 'owner@example.com')"
```

```text
# pattern_match('registry.example.com/checkout/*', spec.containers[0].image)
true
# regex_match('^[^@]+@[^@]+\.[^@]+$', 'owner@example.com')
true
```

`pattern_match` takes a simple wildcard pattern: `*` for any run of characters and `?` for one character, nothing more. `regex_match` takes a full regular expression, so it can express shapes a wildcard cannot, such as "exactly one `@` with something on both sides".

### Split a string, check a version, match labels

Cut the version tag off the image, check a version against a range, and check the Pod's labels against a selector:

```sh
kyverno jp query -i pod.json -u "split(spec.containers[0].image, ':')"
kyverno jp query -i pod.json -u "semver_compare('1.4.2', '>=1.0.0')"
kyverno jp query -i pod.json -u 'label_match(`{"team":"checkout"}`, metadata.labels)'
```

```text
# split(spec.containers[0].image, ':')
[
  "registry.example.com/checkout/web",
  "1.4.2"
]
# semver_compare('1.4.2', '>=1.0.0')
true
# label_match(`{"team":"checkout"}`, metadata.labels)
true
```

`split` returns a list, so add `[1]` to pick the tag alone. `semver_compare` checks the first argument, a version, against the second, a version or a range such as `>=1.0.0`; a bare version such as `1.0.0` as the second argument means "exactly this version". `label_match` checks whether the labels in the second argument satisfy the selector in the first, which is why an object literal goes in backticks.

## Where these show up in a policy

Every one of these functions works the same inside a live `ClusterPolicy` or `Policy`. A `preconditions` block, a `context.apiCall` transform or a `foreach` expression can call `label_match`, `semver_compare` or any other custom function exactly the way you just called it from `kyverno jp query`. That is the point of this whole module: what you prove offline against a sample file runs in the cluster on the very same engine.

## Common pitfalls

> [!WARNING]
> - **Treating `pattern_match` like `regex_match`.** `pattern_match` only knows `*` and `?`. Regular expression syntax in it does not raise an error; it just matches the wrong things. Check which one a policy example really uses.
> - **Calling `trim` with one argument.** Kyverno's `trim` needs the characters to cut as a second argument, for example `' '`.
> - **Reading a bare version as a minimum.** `semver_compare('2.3.1', '2.0.0')` is `false`, because a bare second argument means "exactly 2.0.0". Write `'>=2.0.0'` for "at least".
> - **Trying custom functions in a plain JMESPath tool.** They exist only in Kyverno's engine. Use `kyverno jp`.

## Your mission: kyverno jp Query Lab

You can now pull single values out of a document, clean them with Kyverno's string functions, and test them with a wildcard pattern. Now prove it in a graded mission: query a Pod file for its name, its padded namespace, its upper-case environment label and its first image, and check that image against a wildcard pattern, saving each answer to a file.

Start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-040/module-01/labs/lab-01
```

Read the task in [`question.md`](./labs/lab-01/question.md) and solve it on your own first. When you think you are done, send it for grading:

```sh
astrona submit -c sections/section-040/module-01/labs/lab-01
```

When the mission is done, remove it:

```sh
astrona destroy ats-009-lab-007
```
