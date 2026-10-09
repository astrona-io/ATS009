# Meet kyverno jp query

Astronaut, JMESPath is a query language for JSON, from the same family of ideas as `jq`, or XPath for XML. You give it a document and an expression, and it returns the part of the document, or the computed value, that the expression describes. Think of a star chart and a question about it: "what is the name of the second star in this group?"

Kyverno chose JMESPath for `context.apiCall` transforms, variable substitution (`{{ }}`), `preconditions` and `foreach`: everywhere a policy has to reach into a resource and pull out or test a value. It is a general-purpose language, not a Kyverno invention. What you learn here applies the moment you read a `preconditions` block in any Kyverno policy.

This part introduces the navigation computer itself: the `kyverno jp query` command, its flags, and how to read what it prints.

## Ask your first question

Start with a real chart and a real question. Everything else in this part builds on these two files.

### Save a chart

Save this as `pod.json`. It is a cut-down Pod with one label and two containers:

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

### Read the Pod's name

Ask for `metadata.name`:

```sh
kyverno jp query -i pod.json 'metadata.name'
```

```text
# metadata.name
"checkout-web-7f8c9"
```

Two things to notice. First, the Kyverno CLI repeats your expression on a comment line that starts with `#`, then prints the result. Second, the result is in double quotes: by default, a string comes back JSON-quoted.

## The command and its flags

Now that you have seen one query, here is the full shape of the command and what each flag changes.

### The usage line

```text
kyverno jp query [-i input] [-q query|query]... [flags]
```

| Flag | What it does |
| --- | --- |
| `-i, --input string` | Read the input document from a JSON or YAML file instead of standard input |
| `-q, --query strings` | Read the JMESPath expression from a file. You can repeat it to run several expressions |
| `-c, --compact` | Print compact JSON, with no extra spaces or line breaks |
| `-u, --unquoted` | If the final result is a string, print it without the surrounding `"quotes"` |
| `-h, --help` | Show help for this command |

### Plain text with `-u`

The JSON-quoted form (`"checkout-web-7f8c9"`) is right when another tool reads the output as JSON. To read the answer by eye, or to save it as plain text, add `-u`:

```sh
kyverno jp query -i pod.json -u 'metadata.name'
```

```text
# metadata.name
checkout-web-7f8c9
```

`-u` only changes strings. Lists, objects, numbers and `true`/`false` print the same with or without it.

### Compact lists with `-c`

A list prints over several lines by default. `-c` puts it on one line:

```sh
kyverno jp query -i pod.json -c 'spec.containers[*].name'
```

```text
# spec.containers[*].name
["web","sidecar"]
```

## Other ways to feed the computer

The expression and the document can each come from a file or from standard input. That gives four combinations, and all of them work.

### Read the expression from a file

Put the expression in a file and pass it with `-q`:

```sh
echo 'metadata.labels.team' > query-file
kyverno jp query -i pod.json -q query-file
```

```text
# metadata.labels.team

"checkout"
```

The blank line comes from the line break at the end of `query-file`: the comment line repeats the file's content exactly. You can also pipe either part in instead of naming a file:

```sh
cat query-file | kyverno jp query -i pod.json
cat pod.json | kyverno jp query -q query-file
```

When the CLI reads from standard input, it first prints a short prompt such as `Reading from terminal input.` and `Enter input object and hit Ctrl+D.`, then the same answer.

### Mind the comment line when you save answers

The `# expression` line goes to standard output, together with the result. So when you redirect a query into a file, the file holds **two** lines: the comment and the answer. Keep that in mind when a script or a grader reads the file.

## Common pitfalls

> [!WARNING]
> - **Forgetting `-u` for plain text.** Without it, a string comes back as `"checkout"`, quotes included.
> - **Expecting `-u` to change a list.** It only affects a final result that is a string.
> - **Forgetting the comment line.** `kyverno jp query` prints `# <expression>` before the result, on the same output. A redirected file holds both lines.
> - **A stray line break in a query file.** It shows up as an extra blank line in the output. It does not change the result.
