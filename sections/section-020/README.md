# Section 020: kyverno apply

`kyverno apply` is the command that lets you prove a policy correct before it can ever reject a real request. In this section, you move from writing YAML in an editor to actually running it — first entirely offline against local resource files, with no cluster in the loop at all, then against real objects already living in a cluster, using the exact same command with one extra flag.

This is the single most-used Kyverno CLI command in day-to-day policy authoring, and the one the exam expects you to be fastest with.

---

## What You Will Master

By completing this section, you will acquire two core competencies:
*   **Offline Policy Apply:** Running `kyverno apply` against local resource files with no cluster required, supplying variables through a values file, and reading the CLI's pass/fail summary output.
*   **Cluster-Mode Apply & Policy Reports:** Using `--cluster` to evaluate a candidate policy against resources that already exist in a live cluster, scoping with `--namespace`, and generating a `--policy-report`.

---

## The Learning & Lab Path

This section has one module, paired with a dedicated graded lab on a kind Kubernetes cluster, and concludes with a Capstone Integration Challenge:

### 1. Applying Policies with the Kyverno CLI
*   **Module Reader:** **[Module 1: Applying Policies with the Kyverno CLI](./module-01/course.md)**
    1. [Offline Policy Apply](./module-01/course-01-offline-policy-apply.md)
    2. [Applying Against a Live Cluster & Policy Reports](./module-01/course-02-applying-against-a-live-cluster-and-policy-reports.md)
*   **Practice Lab Sandbox:** **`sections/section-020/module-01/labs/lab-01`**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-020/module-01/labs/lab-01
    ```
*   **Hands-on Objective:** Run `kyverno apply` offline against a policy and a pair of local resource files, then run the same policy with `--cluster --policy-report` against pre-existing objects in a live namespace.

### 2. Section Capstone Challenge
*   **Comprehensive Challenge:** **`sections/section-020/capstone/labs/lab-01` (kyverno apply Integration)**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-020/capstone/labs/lab-01
    ```
*   **Hands-on Objective:** Combine a values file supplying policy variables with an offline apply run, then a scoped `--cluster` audit against a live namespace with a policy report.

---

## Ready for Assessment?

Test your theoretical knowledge and diagnostic reasoning before tackling the practical lab missions:

*   **[Take the Section 020 Knowledge Check Quiz](./quiz.md)**
