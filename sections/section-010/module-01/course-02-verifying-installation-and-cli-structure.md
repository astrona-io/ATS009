# Verifying Installation & CLI Structure

Astronaut, a scanner you have not checked is a scanner you cannot trust. This part shows you how to read the scanner's serial plate with `kyverno version`, how to find out which file your console really runs, how to find your way around the commands with `help`, and how to make the console finish command words for you.

## Confirm the install with `kyverno version`

The first command to run after any install is the version check. It tells you two things at once: that the binary runs at all, and which build it is.

### Read the serial plate

Run the version command:

```sh
kyverno version
```

```text
Version: 1.13.2
Time: 2024-12-10T08:37:07Z
Git commit ID: a96b1a4794b4d25cb0c6d72c05fc6355e95cf65c
```

The CLI prints three facts about itself: the version number, the time the binary was built, and the Git commit it was built from. Notice that the number has no `v` in front of it. The release is called `v1.13.2`, but the binary reports `1.13.2`.

### When the check goes wrong

Two results mean trouble, and each one points at a different cause:

- **`command not found`.** The binary is not installed, or it is not on your `PATH`. Check that the file is in a folder on your `PATH` (`echo $PATH`) and that it may run (`chmod +x /usr/local/bin/kyverno`).
- **It runs, but the version is not the one you installed.** An older copy sits earlier on your tool rack and wins. Ask the shell which file it really runs.

### Find the file your shell runs

Ask the shell where `kyverno` lives, then read its version:

```sh
which kyverno
kyverno version
```

`which` prints the full path of the file the shell runs, for example `/usr/local/bin/kyverno`. `type kyverno` gives the same answer. If the path is not the folder you copied the binary into, another copy is shadowing it.

If you installed with Krew, check `which kubectl-kyverno` and `kubectl kyverno version` instead. `kubectl` finds plugins by searching your `PATH` for `kubectl-*` files, so the same `PATH` rules apply.

## Navigate the subcommand tree

The CLI has a small set of subcommands, and each one has its own help page. Learning to read that help is faster than learning every flag by heart.

### List the subcommands

`kyverno help`, or `kyverno` with no arguments, prints the top-level list:

```sh
kyverno help
```

This is the command list from the `1.13.2` binary, shortened to the lines that matter here:

```text
Available Commands:
  apply       Applies policies on resources.
  completion  Generate the autocompletion script for the specified shell
  create      Helps with the creation of various Kyverno resources.
  docs        Generates reference documentation.
  help        Help about any command
  jp          Provides a command-line interface to JMESPath, enhanced with Kyverno specific custom functions.
  json        Runs tests against any json compatible payloads/policies.
  migrate     Migrate one or more resources to the stored version.
  test        Run tests from a local filesystem or a remote git repository.
  version     Prints the version of Kyverno CLI.
```

The ones you use all the time in this exam domain:

| Subcommand | What it does |
| --- | --- |
| `apply` | Tests policies against resources, from files or from a live cluster. No admission webhook is involved. |
| `test` | Runs a test suite (a `kyverno-test.yaml` file) and compares the real results with the expected ones. |
| `jp` | A command-line tool for JMESPath, the query language Kyverno policies use, with Kyverno's own extra functions. |
| `version` | Prints the CLI's build details. |
| `create` | Writes starter files for policies and test manifests. |
| `completion` | Generates a shell completion script. |

### Read a subcommand's help

Every subcommand has its own `--help`. It is the fastest way to check how a flag is spelled, without leaving the terminal:

```sh
kyverno apply --help
kyverno test --help
kyverno jp query --help
```

Run `kyverno apply --help` now and look for `--resource`, `--cluster` and `--values-file`. You will use those flags a lot when you test policies.

> [!TIP]
> The help text always matches the exact binary you have installed. Web pages may describe a newer or older version. When the two disagree, trust `--help`. In the exam, reading `--help` is faster than searching documentation.

## Turn on shell completion

Shell completion is the console's autocomplete: you type part of a command, press `<TAB>`, and the shell offers the rest. The `kyverno` binary can write the script your shell needs for that.

### Generate the bash script

Write the bash completion script into the folder bash reads at start-up:

```sh
kyverno completion bash > /etc/bash_completion.d/kyverno
```

Writing to `/etc` needs administrator rights on most machines. If yours does, run it as `kyverno completion bash | sudo tee /etc/bash_completion.d/kyverno > /dev/null` instead. For other shells, replace `bash` with `zsh`, `fish` or `powershell`, and load the script the way your shell expects.

Open a new shell, type `kyverno ` (with a space) and press `<TAB>`. The shell now offers the subcommands. After a subcommand name, it offers that subcommand's flags. That helps a lot with commands such as `apply` and `test`, which have many flags.

## Common pitfalls

> [!WARNING]
> - **Expecting `v1.13.2` in the output.** `kyverno version` prints `Version: 1.13.2`, with no `v`. Search the output for the number, not for the release name.
> - **Trusting the first version you see.** If two copies are installed, the one earlier on your `PATH` wins. Always check with `which kyverno`.
> - **Writing the completion script without the right rights.** A plain `>` into `/etc/bash_completion.d/` fails for a normal user. Use `sudo tee`.
> - **Testing completion in the same shell.** The script is read when a shell starts. Open a new shell, or load it with `source /etc/bash_completion.d/kyverno`.

## Your mission: Kyverno CLI Installation Lab

You can now install the Kyverno CLI from a release tarball and prove which version your shell runs. Now prove it in a graded mission: install the `v1.13.2` CLI for Linux `x86_64` in a training solar system where only the controller is running, and show that `kyverno version` reports it.

Start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-010/module-01/labs/lab-01
```

Read the task in [`question.md`](./labs/lab-01/question.md) and solve it on your own first. When you think you are done, send it for grading:

```sh
astrona submit -c sections/section-010/module-01/labs/lab-01
```

When the mission is done, remove it:

```sh
astrona destroy ats-009-lab-001
```
