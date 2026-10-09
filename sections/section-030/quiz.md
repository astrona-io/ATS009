# Section 030 Knowledge Check: kyverno test

Test your understanding of the `kyverno-test.yaml` schema, `results` entries, resource grouping, running test suites, and CI exit codes.

---

## Scenario-Based Questions

### Question 1
You write a `results` entry that lists five resource names under `resources:` with a single `result: pass`. When you run `kyverno test .`, one of those five resources actually fails the rule. What happens?
*   **A)** The entry reports a 4/5 partial pass.
*   **B)** The whole entry fails, because every resource listed in one `results` entry must share the same real outcome.
*   **C)** `kyverno test` averages the outcomes and rounds up to pass.
*   **D)** Nothing — grouped resources are only checked for existence, not for outcome.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** A `results` entry declares one expected outcome for every resource listed under `resources:`. If even one of those resources genuinely evaluates differently, the entry's claim is false, and `kyverno test` fails it. Grouping is a convenience for resources that truly share an outcome, not a way to batch unrelated cases together.
*   **Why others are incorrect:**
    *   *Option A* invents partial-credit scoring that doesn't exist.
    *   *Option C* invents an averaging mechanism.
    *   *Option D* is wrong — grouped resources are each individually evaluated against the declared result.
</details>

---

### Question 2
A `results` entry declares `result: skip` for a resource, but when you run `kyverno test .`, the actual outcome is `fail`. What does this mismatch most likely reveal about your understanding of the resource?
*   **A)** You expected the rule's `match`/`exclude` block to not select this resource at all, but it actually did select it — and the resource failed validation once evaluated.
*   **B)** `skip` and `fail` are interchangeable result values, so this should not be a mismatch.
*   **C)** The policy is broken and needs to be reinstalled.
*   **D)** `skip` can only ever be declared for `generate` rules, so this test entry is invalid syntax.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: A**

*   **Why A is correct:** `skip` means the rule never evaluated the resource at all — typically because `match`/`exclude` excluded it. `fail` means the rule *did* evaluate it and rejected it. A `skip` vs `fail` mismatch is a strong signal that your mental model of the rule's scoping (which resources it actually matches) is wrong, not that the policy itself is broken.
*   **Why others are incorrect:**
    *   *Option B* is wrong — they represent fundamentally different code paths (never evaluated vs. evaluated and rejected).
    *   *Option C* jumps to a conclusion the mismatch doesn't support.
    *   *Option D* invents a restriction that doesn't exist; `skip` is a general-purpose result value.
</details>

---

### Question 3
You run `kyverno test https://github.com/your-org/policies --file-name kyverno-test.yaml` against a repository whose default branch is `main`, but the test manifest you actually want to check only exists on a branch named `policy-rework`. What is the most likely outcome?
*   **A)** `kyverno test` automatically checks every branch and picks the one with a matching filename.
*   **B)** The command fails outright with a "branch not found" error.
*   **C)** It silently tests whatever manifest (or lack of one) exists on `main`, because no `--git-branch` was given.
*   **D)** It merges `main` and `policy-rework` before testing.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: C**

*   **Why C is correct:** Without `-b/--git-branch`, a Git repository target resolves to its default branch. If the manifest you care about only lives on `policy-rework`, omitting the flag means you're testing the wrong (or a nonexistent) manifest on `main`, without any error telling you so.
*   **Why others are incorrect:**
    *   *Option A* invents automatic branch discovery that doesn't exist.
    *   *Option B* is wrong — the default branch does exist, so there's no branch-not-found error, just the wrong content.
    *   *Option D* invents merge behavior with no basis in the command's design.
</details>

---

### Question 4
Your CI pipeline runs `kyverno test .` on every pull request. Over several months, every previously-hard test case in `kyverno-test.yaml` has quietly been deleted whenever it failed, leaving a manifest with zero `results` entries. What does the pipeline report today, and what flag would have caught this months ago?
*   **A)** It reports failure today, because an empty manifest is invalid syntax.
*   **B)** It reports a pass today (there's nothing left to disagree with), and `--require-tests` would have failed the run the moment the suite became empty.
*   **C)** It reports a pass today, and there is no flag that could have caught this.
*   **D)** It reports failure today, and `--warnings-as-errors` would have prevented the deletions.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** With no `results` entries left, there is nothing for `kyverno test` to disagree with, so the run reports success — a false green. `--require-tests` exists specifically to fail a run that discovers zero test cases, turning "the suite was hollowed out" into a build failure instead of silent, permanent green. (The flag is in newer CLIs such as 1.19; the 1.13.2 CLI used in this course's labs does not have it.)
*   **Why others are incorrect:**
    *   *Option A* is wrong — an empty `results` list is syntactically valid; the problem is what it fails to assert, not a parse error.
    *   *Option C* is wrong — `--require-tests` is exactly this flag.
    *   *Option D* misattributes the fix; `--warnings-as-errors` concerns CLI deprecation warnings, not empty test suites.
</details>

---

### Question 5
You've written a mutate rule that should add a default `imagePullPolicy` to every container missing one. How do you assert, inside `kyverno-test.yaml`, that the mutation produces exactly the object you expect — not just that the rule "passed"?
*   **A)** Set `result: pass` and nothing else; a pass implies the mutation was correct.
*   **B)** Provide a `patchedResources` file containing the resource as it should look *after* the mutation, so `kyverno test` diffs it against Kyverno's real output.
*   **C)** Mutate rules cannot be tested with `kyverno test`, only `validate` rules can.
*   **D)** Use `generatedResource` to declare the expected post-mutation object.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `patchedResources` is the field built for exactly this: an expected-after-mutation object that `kyverno test` compares against what Kyverno's mutate rule actually produced, catching cases where the rule runs "successfully" but patches the wrong field or value.
*   **Why others are incorrect:**
    *   *Option A* only confirms the rule executed without error, not that its output is correct.
    *   *Option C* is false — mutate rules are testable, with `patchedResources` as the mechanism.
    *   *Option D* names the wrong field — `generatedResource` is for `generate` rules, not `mutate` rules.
</details>

---

### Question 6
Two teammates each add a `results` entry for the same resource and the same rule, but with opposite `result` values (`pass` in one, `fail` in the other). What does `kyverno test` do?
*   **A)** It takes the first entry it reads and ignores the second silently.
*   **B)** It evaluates every declared entry against the real outcome; whichever entry's declared value doesn't match Kyverno's actual evaluation fails, surfacing the contradiction as a test failure rather than resolving it for you.
*   **C)** It automatically deduplicates conflicting entries and picks the majority result.
*   **D)** It throws a YAML parse error, since duplicate policy/rule/resource combinations are invalid syntax.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `kyverno test` doesn't reconcile contradictory assertions for you — it independently checks each `results` entry against the real evaluation. Kyverno computes exactly one real outcome for that resource/rule pair, so whichever entry claims the opposite fails, and the failure output is what surfaces the contradiction to the team for a human to resolve.
*   **Why others are incorrect:**
    *   *Option A* is wrong — both entries are evaluated, not just the first.
    *   *Option C* invents deduplication/majority logic that doesn't exist.
    *   *Option D* is wrong — this isn't a syntax error, it's a logical contradiction the tool surfaces at test time, not parse time.
</details>

---
