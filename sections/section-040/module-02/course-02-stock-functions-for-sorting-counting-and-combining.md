# Sorting, Counting And Combining With Built-In Functions

Astronaut, once the chart has the right shape, you ask harder questions: which ship has the most restarts, how many ships are running, which names start with a prefix. JMESPath ships with a set of built-in functions for exactly this. Kyverno keeps all of them and adds its own. This part covers the built-in ones a policy author uses most, and the three logic moves `&&`, `||` and `!`.

Every command here uses `pods.json` in `~/jp-playground/`, the list of three Pods under the key `items`. The Pod `checkout-worker-5d4b2` has 3 restarts, `legacy-batch-1a2b3` has 1 and `checkout-web-7f8c9` has 0.

## Sort, pick and count

A function takes a value in brackets and returns an answer. These four answer the questions "in what order", "which one is the biggest", "how many" and "joined into one line".

### Order and the biggest

`sort_by` orders a list by an expression. The expression starts with `&`, which means "run this on each item, later" and is not run on the whole list. `max_by` picks the item with the biggest value:

<!-- astrona:playground:renew -->

```sh
cd ~/jp-playground
kyverno jp query -i pods.json -c 'sort_by(items, &status.restarts)[*].metadata.name'
kyverno jp query -i pods.json -c 'max_by(items, &status.restarts).metadata.name'
```

```text
# sort_by(items, &status.restarts)[*].metadata.name
["checkout-web-7f8c9","legacy-batch-1a2b3","checkout-worker-5d4b2"]
# max_by(items, &status.restarts).metadata.name
"checkout-worker-5d4b2"
```

`sort_by` puts the smallest first. `max_by` returns the whole Pod, so you can keep walking into it with a dot.

### Count and join

`length` counts the items in a list, or the characters in a string. `join` glues a list of strings into one string, with a separator in front:

```sh
kyverno jp query -i pods.json -c 'length(items)'
kyverno jp query -i pods.json -c "length(items[?status.phase=='Running'])"
kyverno jp query -i pods.json -c "items[*].metadata.name | join(', ', @)"
```

```text
# length(items)
3
# length(items[?status.phase=='Running'])
2
# items[*].metadata.name | join(', ', @)
"checkout-web-7f8c9, checkout-worker-5d4b2, legacy-batch-1a2b3"
```

## Test and combine

Filters keep the ships that fit a condition. These functions and operators build the condition.

### Text tests inside a filter

`contains` checks whether a text or a list holds a value. `starts_with` checks the start of a text:

```sh
kyverno jp query -i pods.json -c "items[?contains(metadata.name, 'checkout')].metadata.name"
kyverno jp query -i pods.json -c "items[?starts_with(metadata.name, 'legacy')].metadata.name"
```

```text
# items[?contains(metadata.name, 'checkout')].metadata.name
["checkout-web-7f8c9","checkout-worker-5d4b2"]
# items[?starts_with(metadata.name, 'legacy')].metadata.name
["legacy-batch-1a2b3"]
```

### And, or, not

`&&` needs both sides to be true, `||` needs one side, and `!` turns true into false. Numbers need backticks, like in every JMESPath expression:

```sh
kyverno jp query -i pods.json -c 'items[?status.phase==`Running` && status.restarts > `0`].metadata.name'
kyverno jp query -i pods.json -c "items[?!(status.phase=='Running')].metadata.name"
```

The first command fails to compile. Run it and read the error, which points at the letter `R`. Then run the second command, which works:

```text
# items[?!(status.phase=='Running')].metadata.name
["legacy-batch-1a2b3"]
```

`` `Running` `` is a bare word inside backticks, which is not valid JSON. Write `'Running'` instead, and keep the backticks only for the number:

```sh
kyverno jp query -i pods.json -c "items[?status.phase=='Running' && status.restarts > \`0\`].metadata.name"
```

```text
# items[?status.phase=='Running' && status.restarts > `0`].metadata.name
["checkout-worker-5d4b2"]
```

Inside double quotes, a backslash in front of each backtick stops the shell from treating it as a command.

### Merge objects and convert types

`merge` joins objects, and the right-hand object wins when both have the same key. `to_string` and `to_number` change the type of a value:

```sh
kyverno jp query -i pods.json -c 'merge(items[0].metadata.labels, `{"tier":"edge","release":"blue"}`)'
kyverno jp query -i pods.json -c 'items[1].status.restarts | to_string(@)'
```

```text
# merge(items[0].metadata.labels, `{"tier":"edge","release":"blue"}`)
{"app.kubernetes.io/name":"web","release":"blue","team":"checkout","tier":"edge"}
# items[1].status.restarts | to_string(@)
"3"
```

The label `tier` was `frontend`, and `merge` replaced it with `edge`. The number 3 became the string `"3"`, with quotes.

## Common pitfalls

> [!WARNING]
> - **Forgetting the `&` in `sort_by` and `max_by`.** The second argument is an expression to run on each item, so it starts with `&`. Without it, the engine tries to run it on the whole list.
> - **A bare word in backticks.** `` `Running` `` fails. Strings use single quotes, and only numbers, booleans, lists and objects use backticks.
> - **Mixing up `&&` and `||`.** `a && b` needs both to be true. A filter with the wrong one keeps or drops the wrong ships.
> - **Backticks inside double quotes.** The shell runs them as a command. Put a backslash in front of each backtick, or wrap the expression in single quotes when it has no single quote of its own.
