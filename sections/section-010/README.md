# Section 010: Installing Kyverno CLI

Before you can test a single policy, you need a working `kyverno` binary on your machine. This section gets it there and proves that it works. You learn every common way to install the Kyverno command-line interface (CLI), how to check which version your shell really runs, and how to find your way around its commands without leaving the terminal.

Think of the Kyverno CLI as a handheld rulebook scanner. Inside a cluster, Kyverno is the docking inspector that checks every new ship before it may dock. The CLI carries the same checking logic, but it works offline, in your hand. This section is about getting the scanner and reading its serial plate.

It is the shortest section in the course. Installing a tool is a small skill, but the exam expects you to do it fast and without mistakes, because every other Kyverno CLI task depends on it.

**Curriculum item covered:** Installing Kyverno CLI

---

## What You Will Master

- The two forms of the CLI: the standalone `kyverno` binary and the `kubectl kyverno` plugin, and which install method gives you which.
- Installing a pinned version from a GitHub release tarball, with Homebrew, with Krew, or by building from source.
- Reading `kyverno version` to confirm exactly what you installed, and finding the binary your shell really runs.
- Navigating `kyverno help` and the `--help` of each subcommand.
- Generating a shell completion script with `kyverno completion`.
- Checking a downloaded release against the published `checksums.txt` file.

---

## The Learning Path

This section has one module with a graded mission, a knowledge check, and a capstone that joins it all together. Work through them in this order.

### 1. Installing & Verifying the Kyverno CLI
*   **Module Reader:** **[Module 1: Installing & Verifying the Kyverno CLI](./module-01/course.md)**
    Parts, in reading order:
    1. [Installation Methods](./module-01/course-01-installation-methods.md)
    2. [Verifying Installation & CLI Structure](./module-01/course-02-verifying-installation-and-cli-structure.md)
    3. [Wrap-Up: Mission Debrief](./module-01/course-03-wrap-up.md)
*   **Graded lab:** **[Kyverno CLI Installation Lab](./module-01/labs/lab-01/README.md)**: a `kind` cluster with the Kyverno controller `v1.13.2` already running and no CLI. Read the [task](./module-01/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-010/module-01/labs/lab-01
    astrona submit -c sections/section-010/module-01/labs/lab-01
    ```

### 2. Section Capstone Challenge
*   **Capstone:** **[Kyverno CLI Installation Capstone Lab](./capstone/labs/lab-01/README.md)**: install the pinned `v1.13.2` CLI, prove it is the official release binary, and turn on bash completion. Read the [task](./capstone/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-010/capstone/labs/lab-01
    astrona submit -c sections/section-010/capstone/labs/lab-01
    ```

---

## Ready for Assessment?

Test your knowledge and your reasoning before you start the capstone:

*   **[Take the Section 010 Knowledge Check Quiz](./quiz.md)**
