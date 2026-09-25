# Section 010: Installing Kyverno CLI

Every other section in this repository assumes one thing: that the `kyverno` binary is already on your `PATH` and works. This section is where that assumption becomes true. You will learn every supported way to get the Kyverno CLI onto a machine, how to verify the install actually succeeded, and how to read the CLI's own subcommand tree well enough to navigate `apply`, `test`, and `jp` without reaching for the docs every time.

This is deliberately the shortest section in the curriculum. Installing a CLI is a small, mechanical skill — but the exam expects you to know it cold, because everything else in the "Kyverno CLI" domain depends on it being done correctly.

---

## What You Will Master

By completing this section, you will acquire two core competencies:
*   **Installation Methods:** Installing the standalone `kyverno` binary from a GitHub release tarball, via Homebrew, or as a `kubectl` plugin through Krew — and knowing which invocation form (`kyverno ...` vs `kubectl kyverno ...`) each method produces.
*   **Verification & CLI Structure:** Reading `kyverno version` output to confirm exactly what you installed, navigating `kyverno help` and its subcommand tree, and enabling shell completion.

---

## The Learning & Lab Path

This section has one module, paired with a dedicated graded lab on a kind Kubernetes cluster, and concludes with a Capstone Integration Challenge:

### 1. Installing & Verifying the Kyverno CLI
*   **Module Reader:** **[Module 1: Installing & Verifying the Kyverno CLI](./module-01/course.md)**
    1. [Installation Methods](./module-01/course-01-installation-methods.md)
    2. [Verifying Installation & CLI Structure](./module-01/course-02-verifying-installation-and-cli-structure.md)
*   **Practice Lab Sandbox:** **`sections/section-010/module-01/labs/lab-01`**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-010/module-01/labs/lab-01
    ```
*   **Hands-on Objective:** Install the standalone `kyverno` CLI binary matching the cluster's Kyverno version from its official GitHub release tarball, put it on `PATH`, and prove `kyverno version` reports it correctly.

### 2. Section Capstone Challenge
*   **Comprehensive Challenge:** **`sections/section-010/capstone/labs/lab-01` (Kyverno CLI Installation Integration)**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-010/capstone/labs/lab-01
    ```
*   **Hands-on Objective:** Install a pinned CLI version, prove its integrity against the official release artifact, and enable bash completion for the `kyverno` command.

---

## Ready for Assessment?

Test your theoretical knowledge and diagnostic reasoning before tackling the practical lab missions:

*   **[Take the Section 010 Knowledge Check Quiz](./quiz.md)**
