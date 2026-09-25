# Part 2 — Kyverno's Custom JMESPath Functions

> Prerequisite: [Part 1 — JMESPath Fundamentals via kyverno jp query](./course-01-jmespath-fundamentals-via-kyverno-jp-query.md). Back to: [Landing page](./course.md).

## Why Kyverno adds its own functions

Stock JMESPath gives you a solid general-purpose toolkit — `length`, `contains`, `sort_by`, `to_string`, and the rest of the spec's built-in functions. But policy authors need things stock JMESPath was never designed for: comparing two sets of Kubernetes labels, checking a container image tag against a semantic version constraint, hashing a string, or testing whether one timestamp falls inside a window. Kyverno's JMESPath engine extends the stock function set with exactly these, and they are **only available through Kyverno's engine** — `kyverno jp`, or a live policy — not through a vanilla `jp` CLI or jmespath.org's own playground.

## `kyverno jp function` — your live reference

```
kyverno jp function [function_name]... [flags]
```

List every custom function Kyverno registers:

```sh
kyverno jp function
```

Look up the exact signature and description of one function before you use it — this is the single best habit this module teaches:

```sh
kyverno jp function truncate
```

> [!TIP]
> **Try it — make the CLI your source of truth**
>
> Function behavior (argument order, return type, edge cases) can shift subtly between Kyverno versions. Before writing any custom-function expression, run `kyverno jp function <name>` against the exact CLI version you have installed rather than trusting a half-remembered signature — this one command is faster than searching documentation and is guaranteed to match your installed version.

## A representative tour

The full list runs to several dozen functions across a few natural groups. Some of the ones you'll reach for most often:

| Group | Function | What it's for |
| --- | --- | --- |
| Strings | `to_upper`, `to_lower`, `trim`, `trim_prefix`, `truncate`, `split`, `replace`, `replace_all` | Text shaping — normalizing a label value, trimming a padded field, cutting a tag off an image reference |
| Matching | `pattern_match`, `regex_match`, `compare`, `equal_fold` | Testing a string against a glob-style pattern, a regex, or comparing case-insensitively |
| Kubernetes-aware | `label_match`, `image_normalize` | Comparing two label selectors, or rendering an image reference to its canonical form |
| Encoding/hashing | `base64_encode`, `base64_decode`, `md5`, `sha1`, `sha256`, `x509_decode` | Encoding, decoding, and hashing string values |
| Math (unit-aware) | `add`, `subtract`, `multiply`, `divide`, `modulo`, `round` | Arithmetic that understands Kubernetes quantities (`"500m"`, `"2Gi"`) and durations, not just plain numbers |
| Versions | `semver_compare` | Comparing two semantic version strings |
| Time | `time_now`, `time_add`, `time_diff`, `time_since`, `time_before`, `time_after`, `time_between`, `time_parse`, `time_truncate`, `time_to_cron` | Everything from "is this cert expiring soon" to scheduling logic |
| Structural | `items`, `object_from_lists`, `lookup`, `parse_json`, `parse_yaml` | Reshaping data — turning a map into a list of key/value pairs and back |

## Worked examples

```sh
# Normalize a shouted label value before comparing it
kyverno jp query -i pod.json -u "to_lower('PRODUCTION')"
# → production

# Strip stray whitespace a webhook payload sometimes carries
kyverno jp query -i pod.json -u "trim('  checkout  ')"
# → checkout

# Glob-style match, not regex — '*' wildcards, no full regex syntax
kyverno jp query -i pod.json -u "pattern_match('registry.example.com/checkout/*', spec.containers[0].image)"
# → true

# A real regex, for shapes glob patterns can't express
kyverno jp query -i pod.json -u "regex_match('^[^@]+@[^@]+\\.[^@]+$', 'owner@example.com')"
# → true
```

> [!WARNING]
> **Common pitfall**
>
> `pattern_match` and `regex_match` look interchangeable but are not: `pattern_match` is a simple, non-regex glob match (`*` as a wildcard, nothing else), while `regex_match` runs a full regular expression. Reaching for `pattern_match` with real regex syntax (character classes, anchors beyond what a glob supports) silently does the wrong thing instead of erroring — always confirm which one a policy example is actually using.

## Where these show up in a policy

Every one of these functions works identically inside a live `ClusterPolicy` or `Policy` — a `preconditions` block, a `context.apiCall` transform, or a `foreach` element expression can call `label_match`, `semver_compare`, or any other custom function exactly the way you just called it from `kyverno jp query`. That symmetry is the point of this whole module: what you prove works offline against a sample JSON file is *the exact same engine* that will run in-cluster.

## Reference

- `kyverno jp function` — the complete, version-matched list for your installed CLI, with per-function detail via `kyverno jp function <name>`.
