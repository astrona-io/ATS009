# Defaults, Requests And Debugging Tools

Astronaut, a policy fails when a key is missing and works when you plan for the gap. This last part shows how to give an answer a default, how to query a request the way Kyverno sees it, and how to use the flags `-q`, `-c`, `-u` and the command `kyverno jp parse` when an expression does not behave. It ends with your graded mission.

The file `request.json` in `~/jp-playground/` looks like the admission request Kyverno receives: an `operation`, the user in `userInfo`, and the new object in `object`.

## Ask about a request

Kyverno policies work on `request.object` and on facts about who sent it. You can test all of these without a cluster:

<!-- astrona:playground:renew -->

```sh
cd ~/jp-playground
kyverno jp query -i request.json -c 'request.object.metadata.labels.team'
kyverno jp query -i request.json -u 'request.userInfo.username'
kyverno jp query -i request.json -c "request.operation == 'CREATE'"
```

```text
# request.object.metadata.labels.team
"checkout"
# request.userInfo.username
ci-deployer
# request.operation == 'CREATE'
true
```

A comparison such as `==` returns `true` or `false`, which is what a precondition needs.

## Plan for a missing key

The request has no annotation named `example.com/owner`. Kyverno's engine reports a missing key as an error, and that error can stop a policy. The `||` operator supplies a default when the left side is missing or empty:

```sh
kyverno jp query -i request.json -c 'request.object.metadata.annotations."example.com/owner" || '"'unknown'"
kyverno jp query -i pods.json -c 'items[5]'
```

```text
# request.object.metadata.annotations."example.com/owner" || 'unknown'
"unknown"
# items[5]
null
```

An index past the end of a list is not an error. It gives `null`, so you can use `||` on it too.

## Debug with the CLI flags

The same four flags solve most debugging problems:

| Flag | What it does |
| --- | --- |
| `-i file` | Read the JSON or YAML input from a file |
| `-q file` | Read the expression from a file, which helps with long expressions and quotes |
| `-c` | Print compact JSON on one line |
| `-u` | Print a string without the JSON quotes |

Save a long expression in a file, and run it with `-q`. The CLI prints a blank line after the expression comment in this mode:

```sh
echo "items[?status.phase=='Running'].metadata.name | length(@)" > q.txt
kyverno jp query -i pods.json -q q.txt
```

```text
# items[?status.phase=='Running'].metadata.name | length(@)

2
```

### See how the engine reads it

When a result surprises you, ask `kyverno jp parse` how the engine reads the expression. It prints the syntax tree, which shows each field, index and operator as a separate node. For `items[0].metadata.name` you see a nested tree with `ASTField` nodes for `items`, `metadata` and `name`, and an `ASTIndex` node for the `0`:

```sh
kyverno jp parse 'items[0].metadata.name'
```

The tree is long, so use it when a pipe or a filter groups differently than you thought. Run `kyverno jp function` with no name to list all functions again.

## Your graded mission

Now prove it in a graded mission. Stop the playground first and start the lab, then submit your answers:

```sh
astrona stop ats-009-playground-040-02
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-040/module-02/labs/lab-01
astrona submit -c sections/section-040/module-02/labs/lab-01
```

Read `question.md` in the lab first. When you are done, clean up and, if you want to keep practising, start the playground again:

```sh
astrona destroy ats-009-lab-014
astrona start ats-009-playground-040-02
```

## Common pitfalls

> [!WARNING]
> - **Reading a missing key as null.** A missing object key is an error (`Unknown key`). Only an out-of-range list index gives `null`. Use `||` for the key.
> - **Saving only the answer.** The CLI writes `# <expression>` first, so a redirected file holds the expression and the result. The graders read both.
> - **Quoting trouble on the command line.** When an expression has both single quotes and double quotes, save it in a file and use `-q`.
> - **Skipping `-i`.** An expression with no input file waits on standard input and looks frozen. Press `Ctrl+D`, then add `-i`.
