# Section 020: kyverno apply

`kyverno apply` lets you prove a policy correct before it can turn a real ship away. Inside a cluster, Kyverno is the docking inspector that checks every new spaceship (Pod) before it may dock. With `kyverno apply` you run the same check yourself: first fully offline, against blueprints on paper (local resource files), then against ships already docked in a live cluster, and with mutate, generate, exception and warning rules too.

It is the Kyverno command-line interface (CLI) command you will use most when you write policies, and the one the exam expects you to be fastest with.

**Curriculum item covered:** apply

---

## What You Will Master

- Running `kyverno apply` against local resource files with no cluster, and reading its pass, fail, warn, error and skip summary.
- Using the exit code of `kyverno apply` as a gate in a script or a CI pipeline.
- Supplying the value of a `context` lookup with a values file (`-f`) or `--set` when there is no cluster to ask.
- Using `--cluster` to check a new policy against resources that already exist in a live cluster, limited with `--namespace`.
- Generating a policy report with `--policy-report`.
- Previewing `mutate` and `generate` rules and saving the result with `-o`.
- Passing request data: a user info file (`-u`), `request.operation` and namespace labels.
- Excusing a resource with a `PolicyException` (`-e`), and shaping the exit code with `--audit-warn` and `--warn-exit-code`.
- Reading results with `--table`, `--detailed-results` and `-p`.

---

## The Learning Path

This section has three modules. Each has a playground for free practice, one graded mission, and a summary. A knowledge check and a capstone close the section. Work through them in this order.

### 1. Applying Policies with the Kyverno CLI
*   **Module Reader:** **[Module 1: Applying Policies with the Kyverno CLI](./module-01/course.md)**
    Parts, in reading order:
    1. [Offline Policy Apply](./module-01/course-01-offline-policy-apply.md)
    2. [Supplying Variables With A Values File](./module-01/course-02-supplying-variables-with-a-values-file.md)
    3. [Applying Against a Live Cluster & Policy Reports](./module-01/course-03-applying-against-a-live-cluster-and-policy-reports.md)
    4. [Summary](./module-01/course-04-summary.md)
*   **Playground:** `ats-009-playground-020-01`, a `kind` cluster with Kyverno and the CLI `1.13.2`, two Pods in `apps` and files in `/root/apply-lab/`. See the [playground guide](./module-01/playground/docs/overview.md).
*   **Graded lab:** **[Offline & Cluster Policy Apply Lab](./module-01/labs/lab-01/README.md)** (`ats-009-lab-003`). Read the [task](./module-01/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-020/module-01/labs/lab-01
    astrona submit -c sections/section-020/module-01/labs/lab-01
    ```

### 2. Mutate And Generate With apply
*   **Module Reader:** **[Module 2: Mutate And Generate With apply](./module-02/course.md)**
    Parts, in reading order:
    1. [Mutating Resources And Saving The Result](./module-02/course-01-mutating-resources-and-saving-the-result.md)
    2. [Generating Resources From A Trigger](./module-02/course-02-generating-resources-from-a-trigger.md)
    3. [Request Data: User Info, Operation And Namespace Labels](./module-02/course-03-request-data-user-info-operation-and-namespace-labels.md)
    4. [Summary](./module-02/course-04-summary.md)
*   **Playground:** `ats-009-playground-020-02`, a `kind` cluster with the CLI `1.13.2` and example files in `/root/apply-mutate/`. See the [playground guide](./module-02/playground/docs/overview.md).
*   **Graded lab:** **[Mutate And Generate With apply Lab](./module-02/labs/lab-01/README.md)** (`ats-009-lab-010`). Read the [task](./module-02/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-020/module-02/labs/lab-01
    astrona submit -c sections/section-020/module-02/labs/lab-01
    ```

### 3. Exceptions, Warnings And Exit Codes In Pipelines
*   **Module Reader:** **[Module 3: Exceptions, Warnings And Exit Codes In Pipelines](./module-03/course.md)**
    Parts, in reading order:
    1. [Exceptions With -e](./module-03/course-01-exceptions-with-policy-exceptions.md)
    2. [Warnings And Exit Codes](./module-03/course-02-warnings-and-exit-codes.md)
    3. [Reading The Results](./module-03/course-03-reading-the-results.md)
    4. [Summary](./module-03/course-04-summary.md)
*   **Playground:** `ats-009-playground-020-03`, a `kind` cluster with the CLI `1.13.2` and two Pods in `/root/apply-gate/`. See the [playground guide](./module-03/playground/docs/overview.md).
*   **Graded lab:** **[Exceptions, Warnings And Exit Codes Lab](./module-03/labs/lab-01/README.md)** (`ats-009-lab-011`). Read the [task](./module-03/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-020/module-03/labs/lab-01
    astrona submit -c sections/section-020/module-03/labs/lab-01
    ```

### 4. Section Capstone Challenge
*   **Capstone:** **[kyverno apply Capstone Lab](./capstone/labs/lab-01/README.md)** (`ats-009-lab-004`): check a `ConfigMap`-backed policy offline with a values file, switch it on, and audit the namespace with a policy report. Read the [task](./capstone/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-020/capstone/labs/lab-01
    astrona submit -c sections/section-020/capstone/labs/lab-01
    ```

---

## Ready for Assessment?

Test your knowledge and your reasoning before you start the capstone:

*   **[Take the Section 020 Knowledge Check Quiz](./quiz.yaml)**: 14 questions covering all three modules.
