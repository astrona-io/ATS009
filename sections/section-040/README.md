# Section 040: kyverno jp

Welcome to the final domain in the Kyverno CLI curriculum. Every Kyverno policy you've written so far has leaned on JMESPath somewhere — a `match` filter, a `preconditions` check, a `context.apiCall` transform, a `foreach` element expression. This section hands you the standalone tool for building and debugging those expressions offline: `kyverno jp`, the exact same JMESPath engine Kyverno runs in-cluster, including every Kyverno-specific custom function, available from your terminal with no cluster round-trip required.

By the end of this section, "the policy's JMESPath expression isn't doing what I expect" stops being a live-cluster debugging session and becomes a five-second local check.

---

## What You Will Master

By completing this section, you will acquire two core Kyverno CLI competencies:
*   **JMESPath Fundamentals via `kyverno jp query`:** Core JMESPath syntax — dot notation, indexing, projections, filter expressions, pipe chaining — plus the real `kyverno jp query` flags (`-i`, `-q`, `-c`, `-u`) and the raw-string-vs-JSON-literal distinction that trips up so many first attempts.
*   **Kyverno's Custom JMESPath Functions:** Using `kyverno jp function` as your live, version-matched reference, and applying functions like `label_match`, `semver_compare`, `pattern_match`, `regex_match`, and Kyverno's string/hashing/time helpers the same way a policy's `context` or `preconditions` block would.

---

## The Learning & Lab Path

This section has one module, paired with a dedicated graded lab on a kind Kubernetes cluster, and concludes with a Capstone Integration Challenge:

### 1. JMESPath with the Kyverno CLI
*   **Module Reader:** **[Module 1: JMESPath with the Kyverno CLI](./module-01/course.md)**
    1. [JMESPath Fundamentals via kyverno jp query](./module-01/course-01-jmespath-fundamentals-via-kyverno-jp-query.md)
    2. [Kyverno's Custom JMESPath Functions](./module-01/course-02-kyvernos-custom-jmespath-functions.md)
*   **Practice Lab Sandbox:** **`sections/section-040/module-01/labs/lab-01`**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-040/module-01/labs/lab-01
    ```
*   **Hands-on Objective:** Use `kyverno jp query` against a sample Pod manifest to extract, trim, case-convert, and pattern-match values — the exact building blocks a policy's `context`/`preconditions` block relies on.

### 2. Section Capstone Challenge
*   **Comprehensive Challenge:** **`sections/section-040/capstone/labs/lab-01` (kyverno jp Integration)**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-040/capstone/labs/lab-01
    ```
*   **Hands-on Objective:** Combine stock JMESPath syntax with `semver_compare`, `label_match`, and `regex_match` against a single payload shaped like a real policy's `preconditions`/`context` block, confirming each function's behavior with `kyverno jp function` before relying on it.

---

## Ready for Assessment?

Test your theoretical knowledge and diagnostic reasoning before tackling the practical lab missions:

*   **[Take the Section 040 Knowledge Check Quiz](./quiz.md)**
