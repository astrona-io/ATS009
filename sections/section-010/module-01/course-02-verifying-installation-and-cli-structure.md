# Part 2 — Verifying Installation & CLI Structure

> Prerequisite: [Part 1 — Installation Methods](./course-01-installation-methods.md). Next: [Section 010 Knowledge Check](../quiz.md).

## Confirming the install with `kyverno version`

The first command you should run after any install method is:

```sh
kyverno version
```

This prints build metadata for the binary you just installed — the version tag, build time, git commit, and the Go toolchain it was compiled with. If this command fails (`command not found`), the binary either isn't installed or isn't on your `PATH`. If it succeeds but prints a version you didn't expect, you likely have an older install shadowing the new one earlier in `PATH` — check with `which kyverno` (or `type kyverno`) to see exactly which file your shell is resolving to.

> [!TIP]
> **Try it — confirm which binary your shell resolves**
>
> ```sh
> which kyverno
> kyverno version
> ```
>
> If you installed via Krew, use `which kubectl-kyverno` and `kubectl kyverno version` instead — `kubectl` plugins are resolved through `PATH` lookup for the `kubectl-*` naming convention, not through `kubectl`'s own binary.

## Navigating the subcommand tree

`kyverno help` (or plain `kyverno` with no arguments) prints the top-level subcommand list. The ones you'll use constantly in this domain:

| Subcommand | Purpose |
| --- | --- |
| `apply` | Test policies against resources, locally or against a live cluster — no admission webhook involved. |
| `test` | Run a declared test suite (a `kyverno-test.yaml` manifest) and compare actual results to expected ones. |
| `jp` | A JMESPath command-line interface, extended with Kyverno's own custom functions. |
| `version` | Print CLI build metadata. |
| `create` | Scaffold policy or test-manifest boilerplate. |
| `completion` | Generate a shell completion script. |

Every subcommand supports its own `--help`, which is the fastest way to check exact flag spelling without leaving the terminal:

```sh
kyverno apply --help
kyverno test --help
kyverno jp query --help
```

> [!TIP]
> **Try it — explore before you memorize**
>
> Run `kyverno apply --help` right now. You'll see flags like `--resource`, `--cluster`, and `--values-file` that the next two sections of this curriculum use extensively. Getting comfortable reading `--help` output is a faster path to exam readiness than memorizing every flag up front.

## Enabling shell completion

Like most Cobra-based Go CLIs, `kyverno` can generate a completion script for your shell:

```sh
kyverno completion bash > /etc/bash_completion.d/kyverno
```

(Substitute `zsh`, `fish`, or `powershell` for `bash` as appropriate, and source the resulting script according to your shell's completion-loading convention.) Once loaded, pressing `<TAB>` after `kyverno ` will suggest subcommands, and after a subcommand name it will suggest that subcommand's flags — genuinely useful given how many flags commands like `apply` and `test` carry.

## Reference

- `kyverno help` / `kyverno <subcommand> --help` — always available, always matches the exact binary you have installed (safer than trusting version-drifted documentation).
- `kyverno version` — the single fastest way to confirm what's actually on disk.
