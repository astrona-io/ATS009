# Installation Methods

Astronaut, before you can scan a single ship you need the scanner in your hand. The Kyverno project ships its command-line interface (CLI) through four common channels: a release tarball, Homebrew, Krew and a build from source. This part walks through each one and shows which command name it leaves on your machine.

## Two tools, both called "the Kyverno CLI"

Before you touch a terminal, know that the Kyverno project ships two different files. They do the same work, but you call them by different names.

| What you get | File name on disk | You call it as | Usual source |
| --- | --- | --- | --- |
| Standalone CLI | `kyverno` | `kyverno <subcommand>` | GitHub release tarball, Homebrew, building from source |
| `kubectl` plugin | `kubectl-kyverno` | `kubectl kyverno <subcommand>` | Krew, or building from source |

Both forms run the exact same code. `apply`, `test`, `jp` and every other subcommand behave the same way in each. The only difference is the name of the file, and so the way you type the command.

The plugin form works because of a `kubectl` rule. `kubectl` treats any program on your `PATH` named `kubectl-<name>` as a plugin, and runs it when you type `kubectl <name>`. Picture the same scanner, clipped onto your standard toolbelt. So once `kubectl-kyverno` is installed, `kubectl kyverno version` works.

> [!TIP]
> This course uses the standalone `kyverno` form everywhere. If you installed with Krew instead, read `kubectl kyverno` wherever you see a bare `kyverno` command. The subcommands and flags are the same.

## Method 1: the GitHub release tarball

The most direct way is to download a ready-made binary. A tarball is a packed archive, like a sealed supply crate from the shipyard. Each Kyverno release publishes one crate per operating system and processor type, with a fixed naming pattern.

### Install version 1.13.2 on Linux

Here is a real install: CLI version `v1.13.2` for Linux on an `x86_64` processor. Download the crate, unpack it, and copy the binary onto your tool rack:

```sh
curl -LO https://github.com/kyverno/kyverno/releases/download/v1.13.2/kyverno-cli_v1.13.2_linux_x86_64.tar.gz
tar -xvf kyverno-cli_v1.13.2_linux_x86_64.tar.gz
sudo cp kyverno /usr/local/bin/
```

The archive holds two files, `LICENSE` and a binary named simply `kyverno`. Copying that binary into any folder on your `PATH` finishes the install. `/usr/local/bin` is the usual choice.

### The naming pattern

Every release asset follows this pattern:

```text
kyverno-cli_v{VERSION}_{OS}_{ARCH}.tar.gz
```

For `v1.13.2`, the release has Linux assets for `x86_64`, `arm64` and `s390x`, and macOS assets (`darwin`) for `x86_64` and `arm64`. Windows gets `.zip` files instead of tarballs. If you get the version, the system or the processor wrong, that file simply does not exist, and `curl` downloads an error page instead of a crate.

## Method 2: Homebrew

On macOS or Linux with the Homebrew package manager installed, one command does it:

```sh
brew install kyverno
```

Homebrew installs the standalone `kyverno` binary. It keeps the binary up to date through `brew upgrade`, like any other package.

## Method 3: Krew, the kubectl plugin manager

Krew is a plugin manager for `kubectl`. Use it if you want Kyverno to feel like a normal `kubectl` command:

```sh
kubectl krew install kyverno
```

Krew installs the plugin form, `kubectl-kyverno`, into its own plugin folder on your `PATH`. Check it with:

```sh
kubectl kyverno version
```

Look at how you call it: `kubectl kyverno`, not `kyverno`. As far as your shell and `kubectl` are concerned, this is a real `kubectl` subcommand. Underneath, it is Kyverno's own binary.

## Method 4: building from source

Contributors, or anyone who needs a change that is not released yet, can build the CLI from the source code:

```sh
git clone https://github.com/kyverno/kyverno
cd kyverno
make build-cli
sudo mv ./cmd/cli/kubectl-kyverno/kubectl-kyverno /usr/local/bin/
```

The build target produces a binary named `kubectl-kyverno`, even here. So you get the plugin form. Rename the file, or add a link named `kyverno`, if you want the standalone form instead.

## Which method should you use?

Each method fits a different situation. Pick the one that matches where the CLI will run:

- **A CI pipeline** (continuous integration, the launch checklist every change must clear): the release tarball, pinned to an exact version and downloaded in a setup step. It is repeatable, and it does not need a package manager on the build machine.
- **Your own macOS or Linux machine, where you already use Homebrew:** Homebrew, for easy upgrades.
- **You live in `kubectl` all day and want Kyverno to feel built in:** Krew.
- **You need a fix that is not released yet:** build from source.

## Common pitfalls

> [!WARNING]
> - **Thinking the CLI and the controller must match.** The CLI version and the version of the Kyverno controller in a cluster are separate things. `kyverno apply` and `kyverno test` work with no cluster at all. Still, keep them on the same version for exam and production work, so the CLI's results match what the live docking inspector enforces.
> - **Downloading the wrong asset.** A typo in the version, the system or the processor type gives you an error page, not a crate. `tar` then fails, or you install nothing.
> - **Typing `kyverno` after a Krew install.** Krew gives you `kubectl kyverno`. A bare `kyverno` gives `command not found`.
