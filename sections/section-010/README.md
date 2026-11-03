# Section 010: Installing Kyverno CLI

Before you can test a single policy, you need a working `kyverno` binary on your machine. This section gets it there and proves that it works. You learn every common way to install the Kyverno command-line interface (CLI), how to check which version your shell really runs, and how to find your way around its commands without leaving the terminal.

Think of the Kyverno CLI as a handheld rulebook scanner. Inside a cluster, Kyverno is the docking inspector that checks every new ship before it may dock. The CLI carries the same checking logic, but it works offline, in your hand. This section is about getting the scanner and reading its serial plate.

Installing a tool is a small skill, but the exam expects you to do it fast and without mistakes, because every other Kyverno CLI task depends on it.

**Curriculum item covered:** Installing Kyverno CLI

---

## What You Will Master

- The two forms of the CLI: the standalone `kyverno` binary and the `kubectl kyverno` plugin, and which install method gives you which.
- Installing a pinned version from a GitHub release tarball, with Homebrew, with Krew, or by building from source, and how to upgrade and remove each one.
- Reading `kyverno version` to confirm exactly what you installed, and finding the binary your shell really runs.
- Checking a downloaded release against the published `checksums.txt` file.
- Walking the command tree with `--help`, using the global flags, the experimental switch and `kyverno docs`.
- Generating completion scripts for every shell, and giving the binary the plugin name.
- Scaffolding starter files with `kyverno create`.

---

## The Learning Path

This section has two modules. Each one has its own playground, a graded mission, and a summary. A knowledge check and a capstone close the section. Work through them in this order.

### 1. Installing & Verifying the Kyverno CLI
*   **Module Reader:** **[Module 1: Installing & Verifying the Kyverno CLI](./module-01/course.md)**
    Parts, in reading order:
    1. [Installation Methods](./module-01/course-01-installation-methods.md)
    2. [Verifying Installation & CLI Structure](./module-01/course-02-verifying-installation-and-cli-structure.md)
    3. [Summary](./module-01/course-03-summary.md)
*   **Playground:** `ats-009-playground-010-01`, a `kind` cluster with the Kyverno controller `v1.13.2` running and no CLI. Launch it from the end of the module page.
*   **Graded lab:** **[Kyverno CLI Installation Lab](./module-01/labs/lab-01/README.md)** (`ats-009-lab-001`). Read the [task](./module-01/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-010/module-01/labs/lab-01
    astrona submit -c sections/section-010/module-01/labs/lab-01
    ```

### 2. The Kyverno CLI Toolbox
*   **Module Reader:** **[Module 2: The Kyverno CLI Toolbox](./module-02/course.md)**
    Parts, in reading order:
    1. [Finding Your Way Around the CLI](./module-02/course-01-finding-your-way.md)
    2. [Shell Completion and the Plugin Name](./module-02/course-02-completion-and-the-plugin-name.md)
    3. [Scaffolding Files with `kyverno create`](./module-02/course-03-scaffolding-with-create.md)
    4. [Summary](./module-02/course-04-summary.md)
*   **Playground:** `ats-009-playground-010-02`, with the CLI installed and a few practice files ready.
*   **Graded lab:** **[The Kyverno CLI Toolbox Lab](./module-02/labs/lab-01/README.md)** (`ats-009-lab-009`). Read the [task](./module-02/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-010/module-02/labs/lab-01
    astrona submit -c sections/section-010/module-02/labs/lab-01
    ```

### 3. Section Capstone Challenge
*   **Capstone:** **[Kyverno CLI Installation Capstone Lab](./capstone/labs/lab-01/README.md)** (`ats-009-lab-002`): install the pinned `v1.13.2` CLI, prove it is the official release binary, and turn on bash completion. Read the [task](./capstone/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-010/capstone/labs/lab-01
    astrona submit -c sections/section-010/capstone/labs/lab-01
    ```

---

## Ready for Assessment?

Test your knowledge and your reasoning before you start the capstone:

*   **[Take the Section 010 Knowledge Check Quiz](./quiz.yaml)**
