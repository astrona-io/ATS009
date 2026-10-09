# Section 030: kyverno test

`kyverno apply` proves what a policy does once, on demand. `kyverno test` turns that proof into a standing claim: a test manifest that states exactly what a policy must decide about a fixed set of resources, checked automatically every time the policy or the resources change. Think of it as a pre-flight checklist with the expected answer written next to every line.

This is what makes policy changes safe to merge without a person re-reading every YAML change. If a rewrite of `require-run-as-nonroot` suddenly starts admitting a Pod it used to reject, `kyverno test` catches it in the pipeline before it reaches a real cluster.

**Curriculum item covered:** test

---

## What You Will Master

- The `kyverno-test.yaml` file: `policies`, `resources`, and `results` entries with `policy`, `rule`, `resources`, `kind` and `result`, plus the optional `variables` and `userinfo` files.
- When several resources may share one `results` entry, and why one mismatch fails the whole entry.
- Running `kyverno test` against a local folder or a Git repository, and narrowing a run with `--test-case-selector`.
- Reading the test table: `Pass` means the claim matched, and `Want pass, got fail` shows a wrong claim.
- Using the exit code as a CI gate, and knowing which flags (`--require-tests`, `-o`, `--warnings-as-errors`) only newer CLIs have.

---

## The Learning Path

This section has one module with a graded mission, a knowledge check, and a capstone that joins it all together. Work through them in this order.

### 1. Writing & Running Kyverno Test Suites
*   **Module Reader:** **[Module 1: Writing & Running Kyverno Test Suites](./module-01/course.md)**
    Parts, in reading order:
    1. [Test Manifest Anatomy](./module-01/course-01-test-manifest-anatomy.md)
    2. [Running & Interpreting Test Results](./module-01/course-02-running-and-interpreting-test-results.md)
    3. [Wrap-Up: Mission Debrief](./module-01/course-03-wrap-up.md)
*   **Graded lab:** **[Kyverno Test Suite Lab](./module-01/labs/lab-01/README.md)**: a `kind` cluster with the CLI `1.13.2` and a broken test manifest in `~/kyverno-cli-lab`. Read the [task](./module-01/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-030/module-01/labs/lab-01
    astrona submit -c sections/section-030/module-01/labs/lab-01
    ```

### 2. Section Capstone Challenge
*   **Capstone:** **[kyverno test Capstone Lab](./capstone/labs/lab-01/README.md)**: write a `kyverno-test.yaml` from scratch for two policies, three rules and four Pods, grouping Pods that share a verdict. Read the [task](./capstone/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-030/capstone/labs/lab-01
    astrona submit -c sections/section-030/capstone/labs/lab-01
    ```

---

## Ready for Assessment?

Test your knowledge and your reasoning before you start the capstone:

*   **[Take the Section 030 Knowledge Check Quiz](./quiz.md)**
