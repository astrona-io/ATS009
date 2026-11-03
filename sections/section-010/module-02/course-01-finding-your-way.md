# Finding Your Way Around the CLI

Astronaut, a good scanner comes with its own manual. This part shows you how to walk the command tree, how to read a help page, which flags work on every command, how to reveal the hidden commands, and how to print the whole manual in one go.

## The command tree

The `kyverno` command is a tree. The top level holds the main commands, and some of them have their own branches. Knowing the shape of the tree tells you where to look.

### Two kinds of commands

Some commands do the checking, and others help you around it:

| Group | Commands | What they do |
| --- | --- | --- |
| Checking | `apply`, `test`, `jp` | Run policies against resources, run a test suite, evaluate a JMESPath expression |
| Helping | `create`, `completion`, `docs`, `version`, `migrate` | Write starter files, finish your typing, print the manual, read the serial plate, update stored resources in a cluster |

`migrate` is the odd one out. It rewrites resources that are stored in a cluster to the newest stored version of their type, and you need it only when you upgrade Kyverno itself.

The syntax comes from the command's own help. You name the resource type with `--resource`, and it talks to the cluster in your kubeconfig, so it does nothing useful on a machine with no cluster:

```sh
kyverno migrate --resource policyexceptions.kyverno.io
```

This is the example the help text shows. Remember what it is for: it moves stored objects to the current stored version.

### Walk down a branch

<!-- astrona:playground:renew -->

Commands with branches print their sub-commands in the same help format. Try the two main branches:

```sh
kyverno create --help
kyverno jp --help
```

`create` lists its helpers, such as `test`, `values` and `user-info`. `jp` lists `query`, `function` and `parse`. Go one level deeper and the help is about one command only, for example `kyverno jp query --help`.

## Read a help page

Every help page has the same four parts. Once you know them, you can read any command you have never seen.

### Usage, Examples, Flags, Global Flags

- **Usage** shows the shape of the command, with `[flags]` for options.
- **Examples** shows real command lines. Copy one and change the names.
- **Flags** lists the options of this command only.
- **Global Flags** lists the options that every command accepts.

To find a flag fast, filter the help text instead of reading all of it:

```sh
kyverno apply --help | grep -E -- '--(resource|cluster|values-file)'
```

The output has one line per flag. You see that `--resource`, `--cluster` and `--values-file` exist, each with a short description and its short form.

> [!TIP]
> In the exam, `--help` plus `grep` is the quickest manual. The examples block often holds the exact command you need.

## Global flags

Global flags work on every command. Two of them matter most:

- **`-v` (long form `--v`)** sets the log level. A bigger number prints more detail. Use it when a command fails and the message is too short.
- **`--kubeconfig`** names the kubeconfig file, the file that tells a tool which cluster to talk to. You need it only for commands that read from a cluster, such as `kyverno apply --cluster`. Offline commands never read it.

Here is how they look in a command (do not run it here, there is no second cluster):

```sh
kyverno apply policy.yaml --cluster --kubeconfig <PATH_TO_KUBECONFIG> -v 4
```

The same help page also shows many logging flags such as `--log_dir`. You will almost never need them.

## Experimental commands

Some commands are still being tried out. The project hides them so nobody relies on them by accident. The top-level help tells you how to reveal them: set the environment variable `KYVERNO_EXPERIMENTAL` to `true` or `1`.

### Compare the two lists

List the commands twice, once normally and once with the switch on:

```sh
kyverno help
KYVERNO_EXPERIMENTAL=true kyverno help
```

The second list can be longer. Newer CLIs show extra commands such as `oci` and `fix` only with the switch on. The 1.13.2 list may differ, so compare the two lists yourself and trust what your binary prints. A variable set in front of a command like this lasts for that one command only.

## Print the manual with `kyverno docs`

The `docs` command writes the reference documentation for every command to files. Its own examples set the experimental switch, so do the same. The command creates the folder if it does not exist:

```sh
KYVERNO_EXPERIMENTAL=true kyverno docs -o /root/reference --autogenTag=false
ls /root/reference
```

It writes one markdown file per command. The names follow the pattern `kyverno_<command>.md`, so `kyverno_apply.md` is the page for `apply` and `kyverno_jp_query.md` is the page for `jp query`. The flag `--autogenTag=false` keeps a timestamp out of the files, so two runs give the same text.

## Common pitfalls

> [!WARNING]
> - **Reading a web page instead of `--help`.** The page may describe another version. The binary in your hand is the truth.
> - **Expecting `--kubeconfig` to matter offline.** `apply` with resource files and `test` never talk to a cluster.
> - **Setting the switch in one command and expecting it later.** `KYVERNO_EXPERIMENTAL=true kyverno help` lasts for that one command. Use `export` to keep it for the whole session.
> - **Relying on an experimental command in a pipeline.** Hidden commands can change or disappear between versions.
