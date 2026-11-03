# Kyverno Functions On Real Policy Data

Astronaut, real data hides things. A ConfigMap holds a whole JSON document inside one string. A Secret holds a token in base64. A limit is written as `256Mi` or `500m`, which is text that looks like a number. Kyverno adds functions to the navigation computer so a policy can open all of these. This part uses the file `settings.json` in `~/jp-playground/`, which holds one of each.

Open the instrument manual before you use a function. `kyverno jp function <name>` prints the exact signature, so you never guess the arguments:

<!-- astrona:playground:renew -->

```sh
cd ~/jp-playground
kyverno jp function multiply
kyverno jp function time_since
```

```text
Name: multiply
  Signature: multiply(any, any) any
  Note:      does arithmetic multiplication of two specified values of numbers, quantities, and durations

Name: time_since
  Signature: time_since(string, string, string) string
  Note:      calculate the difference between a start and end period of time where the end may either be a static definition or the then-current time
```

## Unpack text and encodings

The file `settings.json` has a `data.limits` key that holds a JSON document as one string, and a `data.token` key that holds a base64 text.

### Open a string that holds JSON

`parse_json` turns such a string into a real object, so you can walk into it with a dot. `base64_decode` reads a base64 text back into plain text:

```sh
kyverno jp query -i settings.json -c 'parse_json(data.limits)'
kyverno jp query -i settings.json -u 'parse_json(data.limits).memory'
kyverno jp query -i settings.json -u 'base64_decode(data.token)'
```

```text
# parse_json(data.limits)
{"cpu":"500m","memory":"256Mi"}
# parse_json(data.limits).memory
256Mi
# base64_decode(data.token)
checkout-token
```

The opposite move is `base64_encode`, and `to_string` turns an object back into a string. Remember that base64 only hides text from the eye. Anyone can decode it.

### Clean a file path

`path_canonicalize` removes `..` steps, double slashes and a trailing slash. A policy that checks a volume path should clean it first, because `/apps/../checkout//web/` and `/checkout/web` name the same place:

```sh
kyverno jp query -i settings.json -u 'path_canonicalize(path)'
```

```text
# path_canonicalize(path)
/checkout/web
```

## Do math on units and time

Plain JMESPath cannot add `500m` to `1`. Kyverno's arithmetic functions understand Kubernetes quantities and durations, and keep the unit.

### Quantities

Multiply, divide and add keep the unit of a quantity. Numbers go in backticks, as always:

```sh
kyverno jp query -i settings.json -c 'multiply(parse_json(data.limits).memory, `2`)'
kyverno jp query -i settings.json -c 'divide(parse_json(data.limits).cpu, `2`)'
kyverno jp query -i pods.json -c 'add(items[0].spec.containers[0].resources.limits.cpu, items[1].spec.containers[0].resources.limits.cpu)'
```

```text
# multiply(parse_json(data.limits).memory, `2`)
"512Mi"
# divide(parse_json(data.limits).cpu, `2`)
"250m"
# add(items[0].spec.containers[0].resources.limits.cpu, items[1].spec.containers[0].resources.limits.cpu)
"1500m"
```

The two CPU limits `500m` and `1` add up to `1500m`, which is one and a half cores.

### Time

`time_since` measures the time between two moments. The first argument is a layout, and an empty string means the standard format. `time_add` moves a moment forward by a duration:

```sh
kyverno jp query -i settings.json -c "time_since('', startedAt, '2024-03-01T12:30:00Z')"
kyverno jp query -i settings.json -c "time_add(startedAt, '1h30m')"
```

```text
# time_since('', startedAt, '2024-03-01T12:30:00Z')
"2h30m0s"
# time_add(startedAt, '1h30m')
"2024-03-01T11:30:00Z"
```

The ship started at 10:00, so 2 hours and 30 minutes later it is 12:30. The second answer shows 1 hour and 30 minutes after 10:00.

## Build an object from two lists

`object_from_lists` takes a list of keys and a list of values and makes an object. It is the quick way to turn a Pod name list and a restart list into a lookup table:

```sh
kyverno jp query -i pods.json -c 'object_from_lists(items[*].metadata.name, items[*].status.restarts)'
```

```text
# object_from_lists(items[*].metadata.name, items[*].status.restarts)
{"checkout-web-7f8c9":0,"checkout-worker-5d4b2":3,"legacy-batch-1a2b3":1}
```

## Common pitfalls

> [!WARNING]
> - **Guessing a signature.** Run `kyverno jp function <name>` first. A wrong number of arguments fails at compile time, and some functions take a layout as their first argument.
> - **A number without backticks.** In `multiply(x, 2)` the `2` is not a number to JMESPath. Write it as `` `2` ``.
> - **Treating base64 as a lock.** `base64_decode` shows the text to anyone. Do not log decoded secrets or store them in a policy message.
> - **Calling `parse_json` on something that is not a string of JSON.** It fails. Check the value first with a plain query.
