# Shaping Lists And Objects

Astronaut, the real Pods and requests that a policy reads are rarely one flat object. They are lists inside lists, objects with keys that contain dots and slashes, and fields that are sometimes missing. This part gives the navigation computer the moves it needs to flatten a list, cut a slice, ask every value of an object, and build a new, smaller chart out of a big one.

Your playground wrote three files in `~/jp-playground/`. This part uses `pods.json`, a list of three Pods. The Pods are named `checkout-web-7f8c9`, `checkout-worker-5d4b2` and `legacy-batch-1a2b3`. Each one has labels, a `status` with a `phase` and a `restarts` count, and a list of containers. All Pods sit in a list under the key `items`.

## Flatten and slice lists

A projection such as `[*]` keeps the shape of the chart. When a list sits inside every item of another list, the answer becomes a list of lists. Flattening and slicing give you the shape you want.

### Lists inside lists

Ask for the container names of every Pod, first with `[*]` and then with `[]`:

<!-- astrona:playground:renew -->

```sh
cd ~/jp-playground
kyverno jp query -i pods.json -c 'items[*].spec.containers[*].name'
kyverno jp query -i pods.json -c 'items[*].spec.containers[].name'
```

```text
# items[*].spec.containers[*].name
[["web","sidecar"],["worker"],["batch"]]
# items[*].spec.containers[].name
["web","sidecar","worker","batch"]
```

The first answer has one inner list for every Pod. The empty brackets `[]` are the flatten operator: they pour the inner lists into one list. The `-c` flag keeps each answer on one line.

### Take a slice

A slice takes a range of a list, the way a ship takes only the first two docking bays. `[0:2]` means "from item 0 up to, but not including, item 2". A negative index counts from the end:

```sh
kyverno jp query -i pods.json -c 'items[0:2].metadata.name'
kyverno jp query -i pods.json -c 'items[-1].metadata.name'
```

```text
# items[0:2].metadata.name
["checkout-web-7f8c9","checkout-worker-5d4b2"]
# items[-1].metadata.name
"legacy-batch-1a2b3"
```

A slice is a projection, so it returns a list. `[-1]` is one item, so it returns one value.

## Reach into objects

An object has keys instead of positions. JMESPath has a few moves for asking about every value of an object, for building new objects and for keys that need quotes.

### Every value and every key

`*` after a dot asks for every value of an object. `keys(...)` lists the key names. The order of an object's keys is not fixed, so sort the answer before you compare it:

```sh
kyverno jp query -i pods.json -c 'sort(items[0].metadata.labels.*)'
kyverno jp query -i pods.json -c 'sort(keys(items[0].metadata.labels))'
```

```text
# sort(items[0].metadata.labels.*)
["checkout","frontend","web"]
# sort(keys(items[0].metadata.labels))
["app.kubernetes.io/name","team","tier"]
```

### Build a new chart with a multiselect

A multiselect picks several values at once and puts them in a new shape. Square brackets build a list and curly brackets build an object with names you choose:

```sh
kyverno jp query -i pods.json -c 'items[*].[metadata.name, status.phase]'
kyverno jp query -i pods.json -c 'items[*].{name: metadata.name, restarts: status.restarts}'
```

```text
# items[*].[metadata.name, status.phase]
[["checkout-web-7f8c9","Running"],["checkout-worker-5d4b2","Running"],["legacy-batch-1a2b3","Pending"]]
# items[*].{name: metadata.name, restarts: status.restarts}
[{"name":"checkout-web-7f8c9","restarts":0},{"name":"checkout-worker-5d4b2","restarts":3},{"name":"legacy-batch-1a2b3","restarts":1}]
```

The first answer is a list of small lists. The second is a list of small objects with the two keys `name` and `restarts`. A small object like this is a handy way to give a policy only the fields it needs.

### Keys with dots and slashes

Kubernetes labels such as `app.kubernetes.io/name` have dots and a slash in the key. JMESPath reads a dot as "go one level down", so the key must go in double quotes:

```sh
kyverno jp query -i pods.json -c 'items[0].metadata.labels."app.kubernetes.io/name"'
kyverno jp query -i pods.json -c 'items[*].metadata.labels."app.kubernetes.io/name"'
```

```text
# items[0].metadata.labels."app.kubernetes.io/name"
"web"
# items[*].metadata.labels."app.kubernetes.io/name"
["web","worker"]
```

The second Pod is the `worker` and the third Pod has no such label. A projection leaves out items where the value is missing, so the answer has two names, not three. Without the double quotes, the expression `labels.app.kubernetes.io/name` fails: the engine stops at the slash with a syntax error.

## The moves in one table

| Expression | What it does |
| --- | --- |
| `a[*].b[]` | `[]` flattens one level of lists |
| `a[0:2]`, `a[-1]` | A slice returns a list; a negative index counts from the end |
| `obj.*` | Every value of an object |
| `keys(obj)` | The key names of an object |
| `a[*].[x, y]` | A multiselect list: a small list for every item |
| `a[*].{n: x, m: y}` | A multiselect hash: a small object for every item |
| `obj."a.b/c"` | A key with dots or slashes goes in double quotes |

## Common pitfalls

> [!WARNING]
> - **Reading `[*]` and `[]` as the same move.** `[*]` keeps the inner lists. `[]` flattens them. A policy variable that holds a list of lists is usually a missing `[]`.
> - **Trusting the order of object keys.** `keys(...)` and `.*` return values in no fixed order. Wrap them in `sort(...)` before you compare or print them.
> - **Forgetting the quotes on a key with dots.** `labels.app.kubernetes.io/name` fails. Write `labels."app.kubernetes.io/name"`, and wrap the whole expression in single quotes on the command line.
> - **Expecting an item for every Pod.** A projection leaves out items whose value is missing, so the answer can be shorter than the list.
