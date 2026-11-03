# Installing & Verifying the Kyverno CLI

Astronaut, your first mission is to get your tools on board. Kyverno is a policy engine for Kubernetes: inside a cluster it acts as the docking inspector, checking every new spaceship (Pod) against a rulebook before it may dock. The Kyverno command-line interface (CLI) is a handheld rulebook scanner. It carries the same checking logic, but you run it yourself, from your own console, often with no cluster at all.

The Kyverno project ships that scanner in more than one way, and they do not all give you the same thing. Some methods give you a standalone `kyverno` command. Others give you a plugin that you call as `kubectl kyverno`. If you pick the wrong one, or skip the check at the end, you find out three commands later that nothing works. That costs real time, on the job and in the exam.

This module sorts that out once, properly.

```mermaid
flowchart TB
    A["Choose an install method"] -->|"release tarball, Homebrew"| B["kyverno"]
    A -->|"Krew"| C["kubectl kyverno"]
    B --> D["kyverno version"]
    C --> D
    D --> E["kyverno help"]
```

Both install paths end the same way: you read the version, then you explore the commands with `help`.

## Learning objectives

After this module you can:

- Install the Kyverno CLI from a GitHub release tarball for a specific version, operating system and processor type.
- Install the Kyverno CLI with Homebrew and with Krew, and explain how you call it after each one.
- Read `kyverno version` to confirm the exact version, build time and commit you installed.
- Check a downloaded release against the published `checksums.txt` file, and find which `kyverno` file your shell really runs.
- Upgrade the CLI to a new version and remove it again, for each install method.
- List the subcommands with `kyverno help`, and generate a bash completion script for the `kyverno` command.

## Before you start

You need no Kyverno experience for this module. A few shell basics are enough.

### What you should already know

- **Basic shell commands.** Downloading a file with `curl`, unpacking it with `tar`, and copying it with `cp`.
- **What `PATH` is.** `PATH` is the tool rack your console searches when you type a command name. A program only runs by name if it sits in one of the folders on that rack.

### What is waiting in your playground

Your playground is a training solar system (a `kind` cluster) with the Kyverno controller `v1.13.2` already running in the namespace `kyverno`. You are the administrator of its terminal, and `curl`, `tar` and `kubectl` are ready. The `kyverno` command is **not** installed there. Installing it is what you practise while you read.

## How this module is organised

1. **[Installation Methods](./course-01-installation-methods.md)**: the release tarball, Homebrew, the Krew plugin, the container image and building from source, the command name each one gives you, and how to upgrade and remove the CLI.
2. **[Verifying Installation & CLI Structure](./course-02-verifying-installation-and-cli-structure.md)**: reading `kyverno version`, finding the binary your shell runs, checking a download against its published checksum, listing the subcommands, and turning on bash completion. It ends with your graded mission.
3. **[Summary](./course-03-summary.md)**: what you learned, your mission, and cleaning up.

## Why this matters

Every other Kyverno CLI task, from testing a policy to debugging an expression, starts with a working binary. A wrong version on your `PATH` gives you results that do not match what the cluster does, and nothing warns you. Two minutes of checking now saves an hour of confusion later.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
