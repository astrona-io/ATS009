# Wrap-Up: Mission Debrief

Well done, astronaut. You can now ask the navigation computer precise questions and use Kyverno's extra instruments with confidence. Before you move on, look back at what you learned, check yourself, and clean up.

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

You proved the skill in a graded mission, right after the part that taught it:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [kyverno jp Query Lab](./labs/lab-01/README.md) | Kyverno's Custom JMESPath Functions | extract values from a Pod file, clean them with `trim` and `to_lower`, and check an image with `pattern_match` |

If you skipped it, go back to it now. The exam asks for exactly these skills.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. <code>kyverno jp query -i pod.json 'metadata.name'</code> prints the name in double quotes. How do you get plain text?</summary>

Add `-u` (`--unquoted`). It prints a final string result without the quotes.
</details>

<details>
<summary>2. A Kyverno variable ends up holding <code>["web"]</code> instead of <code>web</code>. What is the likely cause?</summary>

The expression uses a projection (`[*]`) or a filter (`[?...]`), which always returns a list. Pick one item with `[0]` when you need a single value.
</details>

<details>
<summary>3. Why does <code>metadata.labels.team == `checkout`</code> fail to compile?</summary>

A backtick literal must be valid JSON, and the bare word `checkout` is not. Use the raw string `'checkout'`, or the JSON string `` `"checkout"` ``.
</details>

<details>
<summary>4. You want to know the argument order of <code>label_match</code> for the CLI you have installed. What do you run?</summary>

`kyverno jp function label_match`. It prints the signature and a note from the binary itself.
</details>

<details>
<summary>5. <code>semver_compare('2.3.1', '2.0.0')</code> returns <code>false</code>. Is 2.3.1 older than 2.0.0?</summary>

No. A bare second argument means "exactly 2.0.0", and 2.3.1 is not that. Write `'>=2.0.0'` to check for "at least 2.0.0".
</details>

## Clean up

Each mission is a whole Kubernetes cluster running on your machine. When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

If the mission is still listed, remove it. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-009-lab-007
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *Try every expression on the navigation computer first: what `kyverno jp` answers on your console is what the policy will see in the cluster.*
