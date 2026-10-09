# Wrap-Up: Mission Debrief

Well done, astronaut. You have the scanner in your hand and you know how to check it. Before you move on, look back at what you learned, check yourself, and clean up.

## What you learned

This module was about getting the Kyverno command-line interface (CLI) onto a machine and proving that it works.

**From [Installation Methods](./course-01-installation-methods.md):**

- The CLI comes in two forms with the same code: the standalone `kyverno` binary and the `kubectl-kyverno` plugin, which you call as `kubectl kyverno`.
- A release tarball follows the pattern `kyverno-cli_v{VERSION}_{OS}_{ARCH}.tar.gz` and holds a binary named `kyverno`. Copy it to a folder on your `PATH`, such as `/usr/local/bin`.
- Homebrew (`brew install kyverno`) gives the standalone form. Krew (`kubectl krew install kyverno`) gives the plugin form. Building from source with `make build-cli` gives `kubectl-kyverno`.
- For a CI pipeline, use the release tarball pinned to an exact version.
- The CLI and the in-cluster controller are separate, but keep them on the same version.

**From [Verifying Installation & CLI Structure](./course-02-verifying-installation-and-cli-structure.md):**

- `kyverno version` prints the version, the build time and the Git commit. For the `v1.13.2` release it prints `Version: 1.13.2`.
- `command not found` means the binary is missing or not on your `PATH`. A wrong version means another copy wins; find it with `which kyverno`.
- `kyverno help` lists the subcommands, and `kyverno <subcommand> --help` shows the flags of the exact binary you have.
- `kyverno completion bash` writes a completion script. Put it in `/etc/bash_completion.d/kyverno` and open a new shell.

## Your mission

You proved the skill in a graded mission, right after the part that taught it:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Kyverno CLI Installation Lab](./labs/lab-01/README.md) | Verifying Installation & CLI Structure | install the pinned `v1.13.2` CLI from its tarball and show its version |

If you skipped it, go back to it now. It is short, and the exam asks for exactly this skill.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. You installed the CLI with Krew. Which command checks the install?</summary>

`kubectl kyverno version`. Krew installs the plugin form, `kubectl-kyverno`, so a bare `kyverno` is not on your `PATH`.
</details>

<details>
<summary>2. <code>ls /usr/local/bin/kyverno</code> shows the file, but <code>kyverno</code> gives <code>command not found</code>. What do you check?</summary>

Whether `/usr/local/bin` is on your `PATH` (`echo $PATH`), and whether the file may run (`chmod +x /usr/local/bin/kyverno`).
</details>

<details>
<summary>3. You installed <code>v1.13.2</code>, but <code>kyverno version</code> shows an older number. What happened?</summary>

An older copy sits in a folder that comes earlier on your `PATH`, so the shell runs that one. `which kyverno` shows which file wins.
</details>

<details>
<summary>4. Which install method gives you the plugin form even though you did not use Krew?</summary>

Building from source. `make build-cli` produces a binary named `kubectl-kyverno`.
</details>

<details>
<summary>5. You wrote the completion script, but <code>&lt;TAB&gt;</code> offers nothing. What is the most likely reason?</summary>

The shell you are typing in started before the script existed. Open a new shell, or run `source /etc/bash_completion.d/kyverno`.
</details>

## Clean up

Each mission is a whole Kubernetes cluster running on your machine. When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

If the mission is still listed, remove it. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-009-lab-001
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *Install the scanner, then read its serial plate: `kyverno version` and `which kyverno` tell you exactly which tool your console runs.*
