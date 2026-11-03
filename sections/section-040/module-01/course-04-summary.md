# Summary

Well done, astronaut. You can now ask the navigation computer precise questions and use Kyverno's extra instruments with confidence. This page recaps each part, lists your mission, and shows you how to clean up the playground.

## What you learned

This module was about JMESPath, the query language inside Kyverno policies, and `kyverno jp`, the tool that runs it from your console.

**From [Meet kyverno jp query](./course-01-jmespath-fundamentals-via-kyverno-jp-query.md):**

- JMESPath is a general query language for JSON. Kyverno uses it in `context`, `preconditions`, `foreach` and `{{ }}` variables.
- `kyverno jp query -i file 'expression'` runs one expression against a JSON or YAML file. `-q` reads the expression from a file; either part can also come from standard input.
- Strings come back JSON-quoted. `-u` prints them as plain text, and `-c` prints compact JSON.
- The CLI prints `# <expression>` before every result, on the same output, so a redirected file holds two lines.

**From [Core JMESPath Syntax And Literals](./course-02-core-jmespath-syntax-and-literals.md):**

- Dot notation walks into objects, `[0]` picks one item, `[*]` asks every item, `[?...]` keeps the items that fit, and `|` passes the answer on, with `@` as the current value.
- Projections and filters always return a list.
- `'text'` is a raw string. Backticks hold JSON literals: numbers, `true`/`false`, `null`, lists and objects. `` `checkout` `` does not compile, and `truncate(@, 9)` needs `` `9` ``.
- Kyverno's engine reports a missing key as an error (`Unknown key ... in path`).

**From [Kyverno's Custom JMESPath Functions](./course-03-kyvernos-custom-jmespath-functions.md):**

- `kyverno jp function` lists the 49 custom functions of the 1.13.2 CLI; `kyverno jp function <name>` shows one signature.
- `trim` needs two arguments: the text and the characters to cut.
- `pattern_match` uses `*` and `?` wildcards only; `regex_match` takes a full regular expression.
- `split` returns a list, `semver_compare` checks a version against a version or a range, and `label_match` checks labels against a selector.
- The functions work the same in `kyverno jp` and in a live policy, because it is the same engine.

## Your mission

You prove the skill in a graded mission, right after the part that teaches it:

| Mission | After the part | What you prove |
| --- | --- | --- |
| [kyverno jp Query Lab](./labs/lab-01/README.md) | Kyverno's Custom JMESPath Functions | extract values from a Pod file, clean them with `trim` and `to_lower`, and check an image with `pattern_match` |

If you have not done it yet, go back to it now. The exam asks for exactly these skills.

## Clean up

The playground is a whole Kubernetes cluster running on your machine. When you are done with this module, remove it, and any mission that is still running.

First, see what is still running:

```sh
astrona list
```

Remove the playground. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-009-playground-040-01
```

If the mission is still listed, remove it the same way with `astrona destroy ats-009-lab-007`. Then check that everything is gone with `astrona list`. It should say `No astrona labs running.`

> *Try every expression on the navigation computer first: what `kyverno jp` answers on your console is what the policy will see in the cluster.*

<!-- astrona:playground:destroy -->
