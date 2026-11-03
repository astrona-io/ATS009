# Section 030: kyverno test

`kyverno apply` proves what a policy does once, on demand. `kyverno test` turns that proof into a standing claim: a test manifest that states exactly what a policy must decide about a fixed set of resources, checked automatically every time the policy or the resources change. Think of it as a pre-flight checklist with the expected answer written next to every line.

This is what makes policy changes safe to merge without a person re-reading every YAML change. If a rewrite of `require-run-as-nonroot` suddenly starts admitting a Pod it used to reject, `kyverno test` catches it in the pipeline before it reaches a real cluster.

**Curriculum item covered:** test

---

## What You Will Master

- The `kyverno-test.yaml` file: `policies`, `resources`, and `results` entries with `policy`, `rule`, `resources`, `kind` and `result`.
- When several resources may share one `results` entry, and why one mismatch fails the whole entry.
- Rule names for autogen rules, and testing `foreach` and `deny` rules.
- Running `kyverno test` against a local folder or a Git repository, and narrowing a run with `--test-case-selector`.
- Reading the test table: `Pass` means the claim matched, and `Want pass, got fail` shows a wrong claim.
- Using the exit code as a CI gate, and knowing which flags (`--require-tests`, `-o`, `--warnings-as-errors`) only newer CLIs have.
- Testing mutate rules with `patchedResources`, and generate and clone rules with `generatedResource` and `cloneSourceResource`.
- Supplying variables (`variables`), the requester (`userinfo`) and waivers (`exceptions`) to a test.
- Keeping many suites in order with one folder for each scenario.

---

## The Learning Path

This section has three modules. Each has a playground for free practice, one graded mission, and a summary. A knowledge check and a capstone close the section. Work through them in this order.

### 1. Writing & Running Kyverno Test Suites
*   **Module Reader:** **[Module 1: Writing & Running Kyverno Test Suites](./module-01/course.md)**
    Parts, in reading order:
    1. [Test Manifest Anatomy](./module-01/course-01-test-manifest-anatomy.md)
    2. [Autogen Names, Foreach And Deny Rules](./module-01/course-02-autogen-names-foreach-and-deny.md)
    3. [Running & Interpreting Test Results](./module-01/course-03-running-and-interpreting-test-results.md)
    4. [Summary](./module-01/course-04-summary.md)
*   **Playground:** `ats-009-playground-030-01`, a terminal with the CLI `1.13.2` and a practice folder `~/kyverno-cli-lab`. See the [playground guide](./module-01/playground/docs/overview.md).
*   **Graded lab:** **[Kyverno Test Suite Lab](./module-01/labs/lab-01/README.md)** (`ats-009-lab-005`). Read the [task](./module-01/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-030/module-01/labs/lab-01
    astrona submit -c sections/section-030/module-01/labs/lab-01
    ```

### 2. Testing Mutate and Generate Rules
*   **Module Reader:** **[Module 2: Testing Mutate and Generate Rules](./module-02/course.md)**
    Parts, in reading order:
    1. [Testing Mutate Rules](./module-02/course-01-testing-mutate-rules.md)
    2. [Testing Generate Rules](./module-02/course-02-testing-generate-rules.md)
    3. [Summary](./module-02/course-03-summary.md)
*   **Playground:** `ats-009-playground-030-02`, the CLI `1.13.2` with a mutate, a generate and a clone policy in `~/kyverno-cli-lab`. See the [playground guide](./module-02/playground/docs/overview.md).
*   **Graded lab:** **[Mutate And Generate Test Lab](./module-02/labs/lab-01/README.md)** (`ats-009-lab-012`). Read the [task](./module-02/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-030/module-02/labs/lab-01
    astrona submit -c sections/section-030/module-02/labs/lab-01
    ```

### 3. Variables, User Info, Exceptions And Large Suites
*   **Module Reader:** **[Module 3: Variables, User Info, Exceptions And Large Suites](./module-03/course.md)**
    Parts, in reading order:
    1. [Variables And User Info](./module-03/course-01-variables-and-user-info.md)
    2. [Exceptions And Skip Results](./module-03/course-02-exceptions-and-skip-results.md)
    3. [Organising Large Test Suites](./module-03/course-03-organising-large-test-suites.md)
    4. [Summary](./module-03/course-04-summary.md)
*   **Playground:** `ats-009-playground-030-03`, the CLI `1.13.2` with two policies, an exception, four Pods, a values file and two user info files. See the [playground guide](./module-03/playground/docs/overview.md).
*   **Graded lab:** **[Variables, Exceptions And Suites Lab](./module-03/labs/lab-01/README.md)** (`ats-009-lab-013`). Read the [task](./module-03/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-030/module-03/labs/lab-01
    astrona submit -c sections/section-030/module-03/labs/lab-01
    ```

### 4. Section Capstone Challenge
*   **Capstone:** **[kyverno test Capstone Lab](./capstone/labs/lab-01/README.md)** (`ats-009-lab-006`): write a `kyverno-test.yaml` from scratch for two policies, three rules and four Pods, grouping Pods that share a verdict. Read the [task](./capstone/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-030/capstone/labs/lab-01
    astrona submit -c sections/section-030/capstone/labs/lab-01
    ```

---

## Ready for Assessment?

Test your knowledge and your reasoning before you start the capstone:

*   **[Take the Section 030 Knowledge Check Quiz](./quiz.yaml)**
