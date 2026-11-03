# Shell Completion and the Plugin Name

Astronaut, two small tricks make the scanner feel like part of your console. The first is completion: you press the tab key and the console finishes the command word. The second is the plugin name: one file name turns `kyverno` into `kubectl kyverno`.

## Completion for every shell

Shell completion is the console's autocomplete. The `kyverno` binary writes the script itself, because it knows its own command tree. Each shell wants the script in its own place and its own language, so you choose the shell when you ask for it.

### Write a script and look at it

<!-- astrona:playground:renew -->

Ask for the bash script and read its first line:

```sh
kyverno completion bash | head -1
```

The line is a comment that says it is a bash completion script for `kyverno`. The zsh script starts with the line `#compdef kyverno` instead. Each shell gets text it can understand, and the content is the same list of commands and flags.

### Where each shell reads it

You can save the script in a folder the shell reads at start-up, or load it into the current shell with `source`. Loading is quick and lasts until you close the shell. Saving is permanent.

| Shell | Save it as | Load it now |
| --- | --- | --- |
| bash | `/etc/bash_completion.d/kyverno` | `source <(kyverno completion bash)` |
| zsh | a file named `_kyverno` in a folder on your `fpath` | `source <(kyverno completion zsh)` |
| fish | `~/.config/fish/completions/kyverno.fish` | read it from that folder at start-up |
| PowerShell | add the output to your profile | `kyverno completion powershell \| Out-String \| Invoke-Expression` |

The bash script needs the `bash-completion` package on the machine, because it uses helper functions from it. If tab does nothing, check that package first.

Try the bash script in the playground. Load it into your shell and complete a command:

```sh
source <(kyverno completion bash)
```

Then type `kyverno cr` and press the tab key. The console completes the word to `kyverno create`. After a space, pressing the tab key twice lists the subcommands.

## The plugin name

The CLI has two forms: `kyverno` and `kubectl kyverno`. They are the same code. The only thing that differs is the file name. This is a `kubectl` rule: any executable on the `PATH` whose name starts with `kubectl-` becomes a `kubectl` subcommand.

### Give the binary a second name

You do not need Krew to get the plugin form. A link named `kubectl-kyverno` that points at the `kyverno` binary is enough:

```sh
ln -s /usr/local/bin/kyverno /usr/local/bin/kubectl-kyverno
kubectl kyverno version
```

The second command prints the same three lines as `kyverno version`: the version number, the build time and the Git commit. A link means that you keep one binary on disk, and an upgrade of the binary upgrades both names.

### Ask `kubectl` which plugins it sees

`kubectl` can list the plugins it finds on the `PATH`:

```sh
kubectl plugin list
```

The list shows the full path of every file named `kubectl-<something>`. Your new link appears in it. If a name does not appear, the file is not on the `PATH` or it is not executable.

> [!TIP]
> When `kubectl kyverno` says `unknown command`, run `kubectl plugin list`. It shows in one step whether `kubectl` sees the plugin at all.

## Common pitfalls

> [!WARNING]
> - **Saving the script but not opening a new shell.** A shell reads completion scripts when it starts. Open a new shell, or load the script with `source`.
> - **Using the bash script in zsh.** Each shell needs its own script. Ask for the one that matches your shell.
> - **A wrong plugin name.** The file must be called exactly `kubectl-kyverno`, with a hyphen. `kubectl_kyverno` or `kubectl kyverno` as a file name does nothing.
> - **A link that points nowhere.** If you move or delete the `kyverno` binary, the `kubectl-kyverno` link breaks with it. `ls -l` shows where a link points.
