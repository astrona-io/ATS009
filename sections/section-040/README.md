# Section 040: kyverno jp

Every Kyverno policy leans on JMESPath somewhere: a `preconditions` check, a `context.apiCall` transform, a `foreach` element, a `{{ }}` variable. JMESPath is the star-chart query language you use to point at one exact value in a JSON document. This section hands you the navigation computer for it: `kyverno jp`, the same JMESPath engine Kyverno runs in the cluster, with every Kyverno custom function, available from your console with no cluster at all.

By the end of this section, "the policy's expression does not do what I expect" stops being a live-cluster debugging session and becomes a five-second check on your own machine.

**Curriculum item covered:** jp

---

## What You Will Master

- The `kyverno jp query` command and its flags `-i`, `-q`, `-c` and `-u`, and the `# expression` line it prints before every result.
- Core JMESPath: dot notation, indexes, `[*]` projections, `[?...]` filters and `|` pipes.
- The difference between raw string literals (`'text'`) and JSON literals (`` `9` ``), and the errors you get when you mix them up.
- `kyverno jp function` as your live, version-matched manual for Kyverno's 49 custom functions.
- Using `trim`, `to_lower`, `split`, `pattern_match`, `regex_match`, `semver_compare` and `label_match` the way a policy's `context` or `preconditions` block would.

---

## The Learning Path

This section has one module with a graded mission, a knowledge check, and a capstone that joins it all together. Work through them in this order.

### 1. JMESPath with the Kyverno CLI
*   **Module Reader:** **[Module 1: JMESPath with the Kyverno CLI](./module-01/course.md)**
    Parts, in reading order:
    1. [Meet kyverno jp query](./module-01/course-01-jmespath-fundamentals-via-kyverno-jp-query.md)
    2. [Core JMESPath Syntax And Literals](./module-01/course-02-core-jmespath-syntax-and-literals.md)
    3. [Kyverno's Custom JMESPath Functions](./module-01/course-03-kyvernos-custom-jmespath-functions.md)
    4. [Wrap-Up: Mission Debrief](./module-01/course-04-wrap-up.md)
*   **Graded lab:** **[kyverno jp Query Lab](./module-01/labs/lab-01/README.md)**: a `kind` cluster with the CLI `1.13.2`, a Pod file in `~/jp-lab/pod.json` and an empty `answers/` folder. Read the [task](./module-01/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-040/module-01/labs/lab-01
    astrona submit -c sections/section-040/module-01/labs/lab-01
    ```

### 2. Section Capstone Challenge
*   **Capstone:** **[kyverno jp Capstone Lab](./capstone/labs/lab-01/README.md)**: combine `split`, `semver_compare`, `label_match` and `regex_match` against one file shaped like a policy's `context` data, reading each function's manual first. Read the [task](./capstone/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-040/capstone/labs/lab-01
    astrona submit -c sections/section-040/capstone/labs/lab-01
    ```

---

## Ready for Assessment?

Test your knowledge and your reasoning before you start the capstone:

*   **[Take the Section 040 Knowledge Check Quiz](./quiz.md)**
