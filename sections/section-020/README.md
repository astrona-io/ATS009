# Section 020: kyverno apply

`kyverno apply` lets you prove a policy correct before it can turn a real ship away. Inside a cluster, Kyverno is the docking inspector that checks every new spaceship (Pod) before it may dock. With `kyverno apply` you run the same check yourself: first fully offline, against blueprints on paper (local resource files), then against ships already docked in a live cluster, with the same command and one extra flag.

It is the Kyverno command-line interface (CLI) command you will use most when you write policies, and the one the exam expects you to be fastest with.

**Curriculum item covered:** apply

---

## What You Will Master

- Running `kyverno apply` against local resource files with no cluster, and reading its pass, fail, warn, error and skip summary.
- Using the exit code of `kyverno apply` as a gate in a script or a CI pipeline.
- Supplying the value of a `context` lookup with a values file (`-f`) or `--set` when there is no cluster to ask.
- Using `--cluster` to check a new policy against resources that already exist in a live cluster, limited with `--namespace`.
- Generating a `ClusterPolicyReport` with `--policy-report`.

---

## The Learning Path

This section has one module with a graded mission, a knowledge check, and a capstone that joins it all together. Work through them in this order.

### 1. Applying Policies with the Kyverno CLI
*   **Module Reader:** **[Module 1: Applying Policies with the Kyverno CLI](./module-01/course.md)**
    Parts, in reading order:
    1. [Offline Policy Apply](./module-01/course-01-offline-policy-apply.md)
    2. [Supplying Variables With A Values File](./module-01/course-02-supplying-variables-with-a-values-file.md)
    3. [Applying Against a Live Cluster & Policy Reports](./module-01/course-03-applying-against-a-live-cluster-and-policy-reports.md)
    4. [Wrap-Up: Mission Debrief](./module-01/course-04-wrap-up.md)
*   **Graded lab:** **[Offline & Cluster Policy Apply Lab](./module-01/labs/lab-01/README.md)**: a `kind` cluster with Kyverno and the CLI `1.13.2`, two Pods in the namespace `apps` and the policy files in `/root/apply-lab/`. Read the [task](./module-01/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-020/module-01/labs/lab-01
    astrona submit -c sections/section-020/module-01/labs/lab-01
    ```

### 2. Section Capstone Challenge
*   **Capstone:** **[kyverno apply Capstone Lab](./capstone/labs/lab-01/README.md)**: check a `ConfigMap`-backed policy offline with a values file, switch it on, and audit the namespace with a policy report. Read the [task](./capstone/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-020/capstone/labs/lab-01
    astrona submit -c sections/section-020/capstone/labs/lab-01
    ```

---

## Ready for Assessment?

Test your knowledge and your reasoning before you start the capstone:

*   **[Take the Section 020 Knowledge Check Quiz](./quiz.md)**
