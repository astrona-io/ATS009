# Section 030: kyverno test

Welcome to the third domain of Kyverno CLI mastery. `kyverno apply` (Section 020) proves a policy's behavior once, on demand. `kyverno test` turns that proof into a standing, repeatable claim: a manifest that states exactly what a policy must decide about a fixed set of resources, checked automatically every time the policy — or the resources — change.

This is the piece that makes policy changes safe to merge without a human re-reading every YAML diff. If a rewrite of `require-run-as-nonroot` accidentally starts admitting a Pod it used to reject, `kyverno test` catches it in CI before it reaches a real cluster.

---

## What You Will Master

By completing this section, you will acquire two core Kyverno CLI competencies:
*   **Test Manifest Anatomy:** The `kyverno-test.yaml` schema — `policies`, `resources`, `results` entries with `policy`/`rule`/`resources`/`kind`/`result`, and the optional `variables` and `userinfo` files for variable- and identity-driven policies.
*   **Running & Interpreting Results:** Invoking `kyverno test` against a local directory or a remote Git repository, selecting individual cases, reading pass/fail output, and using the command's exit code to gate a CI pipeline.

---

## The Learning & Lab Path

This section has one module, paired with a dedicated graded lab on a kind Kubernetes cluster, and concludes with a Capstone Integration Challenge:

### 1. Writing & Running Kyverno Test Suites
*   **Module Reader:** **[Module 1: Writing & Running Kyverno Test Suites](./module-01/course.md)**
    1. [Test Manifest Anatomy](./module-01/course-01-test-manifest-anatomy.md)
    2. [Running & Interpreting Test Results](./module-01/course-02-running-and-interpreting-test-results.md)
*   **Practice Lab Sandbox:** **`sections/section-030/module-01/labs/lab-01`**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-030/module-01/labs/lab-01
    ```
*   **Hands-on Objective:** Diagnose a `kyverno-test.yaml` whose declared expectations don't match Kyverno's real evaluation of two Pods, and fix it — without deleting the inconvenient case — so the suite truthfully reports pass and fail.

### 2. Section Capstone Challenge
*   **Comprehensive Challenge:** **`sections/section-030/capstone/labs/lab-01` (kyverno test Integration)**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-030/capstone/labs/lab-01
    ```
*   **Hands-on Objective:** Author a `kyverno-test.yaml` from scratch covering two policies, three rules, and four resources, grouping resource names wherever their real outcome is identical.

---

## Ready for Assessment?

Test your theoretical knowledge and diagnostic reasoning before tackling the practical lab missions:

*   **[Take the Section 030 Knowledge Check Quiz](./quiz.md)**
