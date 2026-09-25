# ATS009 - KCA: Kyverno CLI

[![Liberapay](https://img.shields.io/badge/Liberapay-Support_Astrona.io-F6C915?logo=liberapay&logoColor=black&style=for-the-badge)](https://liberapay.com/Astrona.io)

Welcome to **ATS009**, a free, hands-on training curriculum built around the **Kyverno CLI** — the offline, cluster-free half of the **Kyverno Certified Associate (KCA)** learning path. This is community training material inspired by the open-source [Kyverno project](https://kyverno.io) (a CNCF Sandbox project); it is not an official Linux Foundation or CNCF exam guide, and no specific vendor exam blueprint is claimed or implied.

Every Kyverno policy you will ever write can — and should — be proven correct before it ever reaches a live admission webhook. The `kyverno` binary is how you do that: install it, apply policies against local resource files, write repeatable test suites, and debug the JMESPath expressions your policies depend on, all without touching a cluster. This repository builds that muscle memory command by command.

---

## The Symmetrical 1:1:1 Learning Framework

To make learning intuitive, digestible, and robust, this curriculum is built around a symmetrical **1:1:1 educational architecture**:

1.  **The Textbook Lesson (`sections/section-XXX/module-01/course.md`):** Narrative, book-style chapters written in a warm, expert "teacher's voice" that explain *why* the Kyverno CLI behaves the way it does, using real-world metaphors, inline command transcripts, and clear diagrams.
2.  **The Interactive Quiz (`sections/section-XXX/quiz.md`):** A scenario-based theoretical knowledge check testing diagnostic reasoning, complete with collapsible answers and technical explanation keys.
3.  **The Dedicated Laboratory (`sections/section-XXX/module-01/`, plus a `sections/section-XXX/capstone/` per section):** A live **kind** Kubernetes cluster sandbox launched instantly via the `astrona` CLI, where you install, apply, test, and query with the real `kyverno` binary and validate your work with automated grading scripts.

---

## Complete Curriculum & Lab Mapping

The training series is divided into **4 sections** covering **4 focused modules**, **4 graded module labs**, and **4 comprehensive Section Capstone Challenges**:

| Section & Domain | Module & Chapter Reader | Practice Lab | astrona CLI Run Command |
| :--- | :--- | :--- | :--- |
| **010: Installing Kyverno CLI** | [M1: Installing & Verifying the CLI](sections/section-010/module-01/course.md) | [lab](sections/section-010/module-01/labs/lab-01) | `astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-010/module-01/labs/lab-01` |
| | **Section Capstone Challenge** | **[capstone](sections/section-010/capstone/labs/lab-01)** | `astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-010/capstone/labs/lab-01` |
| **020: kyverno apply** | [M1: Applying Policies with the CLI](sections/section-020/module-01/course.md) | [lab](sections/section-020/module-01/labs/lab-01) | `astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-020/module-01/labs/lab-01` |
| | **Section Capstone Challenge** | **[capstone](sections/section-020/capstone/labs/lab-01)** | `astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-020/capstone/labs/lab-01` |
| **030: kyverno test** | [M1: Writing & Running Test Suites](sections/section-030/module-01/course.md) | [lab](sections/section-030/module-01/labs/lab-01) | `astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-030/module-01/labs/lab-01` |
| | **Section Capstone Challenge** | **[capstone](sections/section-030/capstone/labs/lab-01)** | `astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-030/capstone/labs/lab-01` |
| **040: kyverno jp** | [M1: JMESPath with the CLI](sections/section-040/module-01/course.md) | [lab](sections/section-040/module-01/labs/lab-01) | `astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-040/module-01/labs/lab-01` |
| | **Section Capstone Challenge** | **[capstone](sections/section-040/capstone/labs/lab-01)** | `astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-040/capstone/labs/lab-01` |

---

## How to Navigate This Course

1.  **Enter a Domain Portal:** Navigate into a domain directory, such as `sections/section-010/`, and open its `README.md` to review the section's core competencies.
2.  **Read the Chapters:** Open and read the narrative chapters in order (`module-01/course.md`, then its numbered parts). Focus on the diagrams, command transcripts, and "Try it" checkpoints.
3.  **Take the Chapter Self-Check:** Challenge yourself with the conceptual questions at the bottom of each course module.
4.  **Test Your Diagnostics:** Open `quiz.md` inside that section and answer its scenario questions. Expand the `<details>` tags to read the teacher's deep-dive explanations.
5.  **Practice the Sandboxes:** Run the module labs (e.g., `sections/section-010/module-01/labs/lab-01`) on a live kind cluster to build real CLI muscle memory.
6.  **Conquer the Capstone Challenges:** Boot up the section's **Capstone Challenge Lab**, solve the integration prompts, and run the automated validation suite to confirm your passing state.
7.  **Simulate the Exam:** Once you have completed all 4 modules, open **`sections/final-domain-quiz.md`** and complete the final closed-book domain exam simulator under a time cap to audit your readiness.

---

## Cluster-Native Focus

Every lab in this repository runs on a **kind** (Kubernetes-in-Docker) cluster spun up by the `astrona` CLI — there are no virtual machines, no host-level Linux administration, and no QEMU images. You work exclusively through the `kyverno` binary and `kubectl` against a real Kyverno installation, exactly as you would against a production cluster.

---

## Support This Project

ATS009 is free Kyverno training material. If it helped you on your policy-engine journey, consider supporting ongoing work and resource development via [Liberapay](https://liberapay.com/Astrona.io).
