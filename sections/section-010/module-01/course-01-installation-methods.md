# Part 1 — Installation Methods

> Prerequisite: [Landing page](./course.md). Next: [Part 2 — Verifying Installation & CLI Structure](./course-02-verifying-installation-and-cli-structure.md).

## Two different things, both called "the Kyverno CLI"

Before touching a terminal, it's worth knowing there are really two distinct artifacts the Kyverno project ships:

| Artifact | Binary name | Invoked as | Typical source |
| --- | --- | --- | --- |
| Standalone CLI | `kyverno` | `kyverno <subcommand>` | GitHub release tarball, Homebrew, building from source |
| `kubectl` plugin | `kubectl-kyverno` | `kubectl kyverno <subcommand>` | Krew, or building from source with the plugin naming convention |

Both wrap the exact same functionality — `apply`, `test`, `jp`, and the rest of the subcommand tree behave identically either way. The only difference is the name on disk and therefore how you type the command. `kubectl` recognizes any binary on your `PATH` named `kubectl-<name>` as a plugin invokable via `kubectl <name>`, which is exactly what makes `kubectl kyverno version` work once `kubectl-kyverno` is installed.

> [!TIP]
> This training material uses the standalone `kyverno` form throughout. If you installed via Krew instead, mentally substitute `kubectl kyverno` everywhere you see a bare `kyverno` command — the subcommands and flags are identical.

## Method 1: GitHub release tarball

The most direct method: download a prebuilt binary for your OS and architecture from the [Kyverno GitHub releases page](https://github.com/kyverno/kyverno/releases). Release assets follow a fixed naming pattern:

```text
kyverno-cli_v{VERSION}_{OS}_{ARCH}.tar.gz
```

For example, installing CLI version `v1.13.2` on Linux x86_64:

```sh
curl -LO https://github.com/kyverno/kyverno/releases/download/v1.13.2/kyverno-cli_v1.13.2_linux_x86_64.tar.gz
tar -xvf kyverno-cli_v1.13.2_linux_x86_64.tar.gz
sudo cp kyverno /usr/local/bin/
```

The extracted archive contains a binary literally named `kyverno`. Copying it anywhere on your `PATH` (`/usr/local/bin` is the conventional choice) completes the install.

> [!WARNING]
> **Common pitfall**
>
> The CLI version and the in-cluster Kyverno controller version are two independent things — installing CLI `v1.13.2` does not require a cluster running controller `v1.13.2`. `kyverno apply` and `kyverno test` work entirely offline without any cluster at all. That said, for exam and production work you should keep them aligned to avoid subtle behavior differences between what the CLI simulates and what the live admission controller actually enforces.

## Method 2: Homebrew

On macOS or Linux with [Homebrew](https://brew.sh) installed:

```sh
brew install kyverno
```

Homebrew installs the standalone `kyverno` binary and keeps it updated through `brew upgrade` like any other formula.

## Method 3: Krew (kubectl plugin manager)

If you'd rather have Kyverno feel like a native `kubectl` subcommand, install it through [Krew](https://krew.sigs.k8s.io/):

```sh
kubectl krew install kyverno
```

Krew installs the plugin form, `kubectl-kyverno`, onto your `PATH` under Krew's own plugin directory. Verify it with:

```sh
kubectl kyverno version
```

Note the invocation: `kubectl kyverno`, not `kyverno`. This is a real `kubectl` subcommand as far as your shell and `kubectl` itself are concerned — it just happens to be Kyverno's binary underneath.

## Method 4: Building from source

For contributors or anyone who needs an unreleased commit, the project can be built directly:

```sh
git clone https://github.com/kyverno/kyverno
cd kyverno
make build-cli
sudo mv ./cmd/cli/kubectl-kyverno/kubectl-kyverno /usr/local/bin/
```

Note that the build target produces a binary named `kubectl-kyverno` even here — rename or symlink it to `kyverno` if you want the standalone invocation form instead of the `kubectl` plugin form.

## Which method should you use?

- **CI pipelines:** the release tarball, pinned to an exact version, downloaded in a setup step — reproducible and doesn't depend on a package manager being present on the runner.
- **Local development on macOS/Linux with Homebrew already in your toolchain:** Homebrew, for easy upgrades.
- **You already live inside `kubectl` muscle memory and want Kyverno to feel native:** Krew.
- **Testing an unreleased fix:** build from source.

## Reference

- [Kyverno CLI releases](https://github.com/kyverno/kyverno/releases) — the authoritative source for exact asset names per version.
- [Krew plugin index](https://krew.sigs.k8s.io/plugins/) — confirms the plugin is still published under the name `kyverno`.
