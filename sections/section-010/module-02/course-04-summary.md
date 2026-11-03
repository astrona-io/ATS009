# Summary

Well done, astronaut. The toolbox is open and you know what each tool does. Before you move on, look back at what you learned, check yourself, and clean up.

## What you learned

This module was about the helper commands around the Kyverno command-line interface (CLI).

**From [Finding Your Way Around the CLI](./course-01-finding-your-way.md):**

- The command tree has checking commands (`apply`, `test`, `jp`) and helper commands (`create`, `completion`, `docs`, `version`, `migrate`).
- A help page has Usage, Examples, Flags and Global Flags. `kyverno <command> --help | grep` finds a flag fast, and the help of your binary beats any web page.
- Global flags work on every command: `-v` sets the log level, and `--kubeconfig` names the cluster file for commands that read from a cluster.
- Experimental commands stay hidden until you set `KYVERNO_EXPERIMENTAL` to `true` or `1`.
- `KYVERNO_EXPERIMENTAL=true kyverno docs -o <folder>` writes one `kyverno_<command>.md` file per command.

**From [Shell Completion and the Plugin Name](./course-02-completion-and-the-plugin-name.md):**

- `kyverno completion bash|zsh|fish|powershell` prints a script for that shell. Save it where the shell reads it, or load it with `source <(...)`.
- A completion script is read when a shell starts. Open a new shell after you save it.
- Any executable named `kubectl-kyverno` on the `PATH` gives you `kubectl kyverno`. A link to the `kyverno` binary is enough, and `kubectl plugin list` shows the plugins `kubectl` sees.

**From [Scaffolding Files with `kyverno create`](./course-03-scaffolding-with-create.md):**

- `kyverno create test`, `values` and `user-info` write starter files for the CLI. `exception` and `metrics-config` write Kubernetes objects.
- Without `-o` the file goes to the screen. With `-o <path>` it goes to disk.
- The values of `--pass` and `--fail` are policy, rule, resource, namespace and kind, in that order.
- A scaffold is a form, not a finished file. Read it before you use it.

## Your mission

You proved the skill in a graded mission, right after the part that taught it:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [The Kyverno CLI Toolbox Lab](./labs/lab-01/README.md) | Scaffolding Files with `kyverno create` | print the reference, write a zsh completion script, add the plugin name, scaffold a test file and a user-info file |

If you skipped it, go back to it now. Every step takes one command.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. You forgot the exact name of a flag of <code>kyverno apply</code>. What is the fastest way to find it?</summary>

`kyverno apply --help`, filtered with `grep` if you like. It shows the flags of the binary you have.
</details>

<details>
<summary>2. The top-level help shows no <code>oci</code> command, but a colleague says the CLI has one. What do you try?</summary>

Set the experimental switch for one command: `KYVERNO_EXPERIMENTAL=true kyverno help`. Experimental commands stay hidden until it is on.
</details>

<details>
<summary>3. You saved <code>kyverno completion zsh</code> output in the right folder, but the tab key does nothing. Why?</summary>

The shell reads completion scripts when it starts. Open a new shell, or load the script with `source <(kyverno completion zsh)`.
</details>

<details>
<summary>4. <code>kubectl kyverno version</code> says <code>unknown command</code>. How do you find the cause?</summary>

Run `kubectl plugin list`. If no `kubectl-kyverno` file is listed, it is missing from the `PATH`, misspelled, or not executable.
</details>

<details>
<summary>5. You ran <code>kyverno create user-info -u alice@example.com</code> and nothing is on disk. Why?</summary>

Without `-o <path>` the command prints the file to the screen. Add `-o user-info.yaml`.
</details>

## Clean up

Each playground and each mission is a whole Kubernetes cluster running on your machine. When you are done with this module, remove the ones you no longer need.

First, see what is still running:

```sh
astrona list
```

Remove the playground. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-009-playground-010-02
```

If the mission is still listed, remove it as well:

```sh
astrona destroy ats-009-lab-009
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *Know your toolbox: `--help` finds the flag, the tab key finishes the word, and `kyverno create` hands you the form.*

<!-- astrona:playground:destroy -->
