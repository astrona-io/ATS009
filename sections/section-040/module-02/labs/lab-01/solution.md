# Solution

Work in the lab folder, and save each answer with a redirect. Run `astrona submit` after each step if you want a pass or fail per check.

```sh
cd ~/jp-lab
```

## Step 1: the busiest Pod

`max_by` takes the list and an expression that starts with `&`. It returns the whole Pod, so walk into it with a dot:

```sh
kyverno jp query -i pods.json -u 'max_by(items, &status.restarts).metadata.name' > answers/busiest-pod.txt
```

The answer is `checkout-worker-5d4b2`.

## Step 2: count the Running Pods

```sh
kyverno jp query -i pods.json "length(items[?status.phase=='Running'])" > answers/running-count.txt
```

The answer is `2`.

## Step 3: the sorted label keys

The order of keys is not fixed, so sort the list:

```sh
kyverno jp query -i pods.json -c 'sort(keys(items[0].metadata.labels))' > answers/label-keys.txt
```

The answer is `["app.kubernetes.io/name","team","tier"]`.

## Step 4: the token

```sh
kyverno jp query -i settings.json -u 'base64_decode(data.token)' > answers/token.txt
```

The answer is `checkout-token`.

## Step 5: the doubled memory limit

`data.limits` is a string, so open it with `parse_json` first. The number `2` goes in backticks:

```sh
kyverno jp query -i settings.json -u 'multiply(parse_json(data.limits).memory, `2`)' > answers/memory.txt
```

The answer is `512Mi`.

## Step 6: the time since the start

The first argument is a layout, and an empty string means the standard format:

```sh
kyverno jp query -i settings.json -u "time_since('', startedAt, '2024-03-01T12:30:00Z')" > answers/uptime.txt
```

The answer is `2h30m0s`.

## Check your work

Each answer file holds a `# expression` line and the result. `solution/apply.sh` writes the same reference answers and is used only by `astrona test`.
