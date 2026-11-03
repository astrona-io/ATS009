# Section 040: kyverno jp

Every Kyverno policy leans on JMESPath somewhere: a `preconditions` check, a `context.apiCall` transform, a `foreach` element, a `{{ }}` variable. JMESPath is the star-chart query language you use to point at one exact value in a JSON document. This section hands you the navigation computer for it: `kyverno jp`, the same JMESPath engine Kyverno runs in the cluster, with every Kyverno custom function, available from your console with no cluster at all.

By the end of this section, "the policy's expression does not do what I expect" stops being a live-cluster debugging session and becomes a five-second check on your own machine.

**Curriculum item covered:** jp

---

## What You Will Master

- The `kyverno jp query` command and its flags `-i`, `-q`, `-c` and `-u`, and the `# expression` line it prints before every result.
- Core JMESPath: dot notation, indexes, `[*]` projections, `[?...]` filters and `|` pipes.
- The difference between raw string literals (`'text'`) and JSON literals (`` `9` ``), and the errors you get when you mix them up.
- `kyverno jp function` as your live, version-matched manual for Kyverno's 49 custom functions, and `kyverno jp parse` to see how the engine reads an expression.
- Using `trim`, `to_lower`, `split`, `pattern_match`, `regex_match`, `semver_compare` and `label_match` the way a policy's `context` or `preconditions` block would.
- Shaping real policy data: flatten, slices, multiselects, quoted keys, `sort_by`, `max_by`, `merge`, `parse_json`, base64, quantity and time math, and `||` defaults.

---

## The Learning Path

This section has two modules. Each one has its own playground, a graded mission, and a summary. A knowledge check and a capstone close the section. Work through them in this order.

### 1. JMESPath with the Kyverno CLI
*   **Module Reader:** **[Module 1: JMESPath with the Kyverno CLI](./module-01/course.md)**
    Parts, in reading order:
    1. [Meet kyverno jp query](./module-01/course-01-jmespath-fundamentals-via-kyverno-jp-query.md)
    2. [Core JMESPath Syntax And Literals](./module-01/course-02-core-jmespath-syntax-and-literals.md)
    3. [Kyverno's Custom JMESPath Functions](./module-01/course-03-kyvernos-custom-jmespath-functions.md)
    4. [Summary](./module-01/course-04-summary.md)
*   **Playground:** `ats-009-playground-040-01`, a `kind` cluster with the CLI `1.13.2` and one Pod file in `~/jp-playground/`. Launch it from the end of the module page.
*   **Graded lab:** **[kyverno jp Query Lab](./module-01/labs/lab-01/README.md)** (`ats-009-lab-007`). Read the [task](./module-01/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-040/module-01/labs/lab-01
    astrona submit -c sections/section-040/module-01/labs/lab-01
    ```

### 2. Advanced JMESPath: Functions, Projections And Real Policy Data
*   **Module Reader:** **[Module 2: Advanced JMESPath](./module-02/course.md)**
    Parts, in reading order:
    1. [Shaping Lists And Objects](./module-02/course-01-shaping-lists-and-objects.md)
    2. [Sorting, Counting And Combining With Built-In Functions](./module-02/course-02-stock-functions-for-sorting-counting-and-combining.md)
    3. [Kyverno Functions On Real Policy Data](./module-02/course-03-kyverno-functions-on-real-policy-data.md)
    4. [Defaults, Requests And Debugging Tools](./module-02/course-04-defaults-requests-and-debugging-tools.md)
    5. [Summary](./module-02/course-05-summary.md)
*   **Playground:** `ats-009-playground-040-02`, with the CLI and three files in `~/jp-playground/`: a list of Pods, a request and a settings file.
*   **Graded lab:** **[Advanced JMESPath Lab](./module-02/labs/lab-01/README.md)** (`ats-009-lab-014`). Read the [task](./module-02/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-040/module-02/labs/lab-01
    astrona submit -c sections/section-040/module-02/labs/lab-01
    ```

### 3. Section Capstone Challenge
*   **Capstone:** **[kyverno jp Capstone Lab](./capstone/labs/lab-01/README.md)** (`ats-009-lab-008`): combine `split`, `semver_compare`, `label_match` and `regex_match` against one file shaped like a policy's `context` data, reading each function's manual first. Read the [task](./capstone/labs/lab-01/question.md), solve it, then
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-040/capstone/labs/lab-01
    astrona submit -c sections/section-040/capstone/labs/lab-01
    ```

---

## Ready for Assessment?

Test your knowledge and your reasoning before you start the capstone:

*   **[Take the Section 040 Knowledge Check Quiz](./quiz.yaml)**
