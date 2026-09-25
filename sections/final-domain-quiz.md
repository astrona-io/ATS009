# KCA Kyverno CLI Certification Quiz

Welcome to the Final Domain Certification Quiz for the **ATS009: Kyverno CLI** curriculum. This comprehensive test contains **8 high-signal, scenario-based questions** covering all 4 modules across the 4 sections.

To simulate exam-style pressure:
*   Answer all 8 questions without consulting external documentation or the Kyverno CLI.
*   Allow yourself a maximum of **15 minutes** to complete the entire test.
*   Once finished, scroll to the very bottom to check the **Audit and Review Key** to trace any incorrect answers back to their exact section and module chapters.

---

## The Exam Simulator

### Question 1
You need to install the Kyverno CLI on a fresh Linux x86_64 CI runner that has no Homebrew and no `krew`, and the pipeline must pin an exact, reproducible version. Which approach is most appropriate?
*   **A)** `go install github.com/kyverno/kyverno/cmd/cli/kubectl-kyverno@latest`, since `@latest` is the most reproducible option.
*   **B)** Download the pinned release tarball for the target OS/arch directly from the `kyverno/kyverno` GitHub Releases page, extract it, and place the binary on `PATH`.
*   **C)** `kubectl krew install kyverno`, since Krew ships with every `kubectl` installation by default.
*   **D)** `apt install kyverno-cli`, since Kyverno publishes an official APT repository for all distributions.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** A pinned release tarball from GitHub Releases is self-contained, requires no package manager to be preinstalled, and lets you pin an exact version string in the download URL — exactly what a reproducible CI setup step needs.
*   **Why others are incorrect:**
    *   *Option A* uses `@latest`, which is the opposite of reproducible — it can silently pull a newer version on a later CI run.
    *   *Option C* is wrong on a factual premise — Krew itself is a separate plugin manager that must be installed first; it does not ship with `kubectl`.
    *   *Option D* invents a package repository Kyverno does not publish.
</details>

---

### Question 2
After installing the Kyverno CLI via the release tarball, `kyverno version` fails with `command not found`, even though `ls /usr/local/bin/kyverno` shows the file exists. What is the most likely cause?
*   **A)** The Kyverno controller is not installed in the cluster.
*   **B)** `/usr/local/bin` is not on the current shell's `PATH`, or the binary was extracted without executable permission.
*   **C)** The CLI can only run inside a pod, never on a bare host.
*   **D)** `kyverno version` requires a `kubeconfig` to even start.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `command not found` is a shell PATH-resolution error, not a Kyverno error — either the directory holding the binary isn't in `PATH`, or the extracted file is missing its executable bit (`chmod +x`). Both are common mistakes right after a manual tarball install.
*   **Why others are incorrect:**
    *   *Option A* is irrelevant — the CLI binary itself doesn't depend on a controller being installed anywhere to simply exist on `PATH`.
    *   *Option C* is false — the CLI is a standalone host binary.
    *   *Option D* is false — `kyverno version` is a purely local, offline command with no cluster dependency.
</details>

---

### Question 3
You want to check whether a policy you're still drafting would pass against a resource manifest, and this machine has no `kubeconfig` configured at all. Which command lets you do this?
*   **A)** `kubectl apply --dry-run=server -f policy.yaml`
*   **B)** `kyverno apply policy.yaml --resource resource.yaml`
*   **C)** `kyverno apply policy.yaml --cluster`
*   **D)** `kyverno test policy.yaml --resource resource.yaml`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `kyverno apply` with `-r`/`--resource` evaluates a policy against local resource files entirely offline — no cluster, no `kubeconfig`, nothing installed.
*   **Why others are incorrect:**
    *   *Option A* requires a live API server to dry-run against, which the question rules out.
    *   *Option C* needs `--cluster`, which requires a working `kubeconfig` pointed at a real cluster.
    *   *Option D* names the wrong subcommand — `kyverno test` runs a declared `kyverno-test.yaml` test suite, not an ad-hoc apply.
</details>

---

### Question 4
You run `kyverno apply policy.yaml --cluster --namespace orders --policy-report`. What does this produce, compared to the plain default output?
*   **A)** The exact same plain-text summary; `--policy-report` only changes the exit code.
*   **B)** A `PolicyReport`/`ClusterPolicyReport` object (YAML) describing pass/fail results for the evaluated resources, instead of the plain-text pass/fail/warn/error/skip summary line.
*   **C)** It deletes any existing PolicyReports in the `orders` namespace before running.
*   **D)** It silently switches from offline mode to enforcing mode on the live cluster.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `--policy-report` changes the CLI's output format to an actual `PolicyReport`-shaped YAML object you can inspect, pipe to `kubectl apply -f -`, or feed into other tooling — instead of the human-readable one-line summary.
*   **Why others are incorrect:**
    *   *Option A* is wrong — the output format materially changes, not just the exit code.
    *   *Option C* invents destructive behavior `kyverno apply` does not perform.
    *   *Option D* is wrong — `kyverno apply --cluster` only evaluates; it never touches Kyverno's admission enforcement configuration.
</details>

---

### Question 5
You write a `kyverno-test.yaml` `results` entry that lists five resource names under `resources:` with a single `result: pass`. When you run `kyverno test .`, one of those five resources actually evaluates to a fail. What happens?
*   **A)** The entry reports a 4/5 partial pass.
*   **B)** The whole entry fails, because every resource listed in one `results` entry must share the same real outcome.
*   **C)** `kyverno test` averages the outcomes and rounds up to pass.
*   **D)** Nothing — grouped resources are only checked for existence, not outcome.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** A `results` entry declares one expected outcome shared by every resource listed under `resources:`. If even one of those resources genuinely evaluates differently, the entry's claim is false and `kyverno test` fails it.
*   **Why others are incorrect:**
    *   *Option A* invents partial-credit scoring that doesn't exist.
    *   *Option C* invents an averaging mechanism.
    *   *Option D* is wrong — every grouped resource is individually evaluated against the declared result.
</details>

---

### Question 6
Your CI pipeline runs `kyverno test .` on every pull request. Over several months, every previously hard test case in `kyverno-test.yaml` has quietly been deleted whenever it failed, leaving a manifest with zero `results` entries. What does the pipeline report today, and what would have caught this months ago?
*   **A)** `kyverno test .` fails automatically on an empty `results` list, so this was never actually possible.
*   **B)** It reports success (there is nothing left to fail), and the `--require-tests`-style safeguard — failing when a policy/resource has no matching test coverage — would have caught the silent deletions.
*   **C)** It reports success, and there is no way to guard against this class of problem.
*   **D)** It reports failure, because Kyverno requires at least one `results` entry per policy file.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** A `kyverno-test.yaml` with no `results` entries has nothing to assert, so `kyverno test .` reports a clean pass — a classic false sense of security. A coverage-enforcing flag catches exactly this: it fails the run when policies or resources exist with no corresponding test assertions, which is the guardrail that should have been wired into CI from the start.
*   **Why others are incorrect:**
    *   *Option A* is wrong — an empty `results` list is valid, if useless, input; it does not error.
    *   *Option C* is wrong — a coverage-enforcing safeguard exists precisely for this failure mode.
    *   *Option D* invents a minimum-entries requirement that doesn't exist.
</details>

---

### Question 7
You run `kyverno jp query -i pod.json 'metadata.name'` with no other flags and get back `"checkout-web-7f8c9"` — quotes included. Which flag makes the same query print `checkout-web-7f8c9` without the surrounding quotes?
*   **A)** `-c` / `--compact`
*   **B)** `-u` / `--unquoted`
*   **C)** `-q` / `--query`
*   **D)** There is no such flag; you must pipe the output through a tool like `tr` to strip the quotes.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `-u`/`--unquoted` does exactly this — when the final result is a string, it prints without the JSON `"quotes"` that wrap it by default.
*   **Why others are incorrect:**
    *   *Option A* controls JSON whitespace compactness, not quoting.
    *   *Option C* reads the query expression itself from a file — unrelated to output formatting.
    *   *Option D* describes an unnecessary workaround, since the flag that does this already exists.
</details>

---

### Question 8
A colleague writes a Kyverno `ClusterPolicy` `preconditions` block using `label_match(requiredSelector, request.object.metadata.labels)`, but the rule isn't behaving as expected once deployed to the cluster. What is the fastest way to isolate whether the problem is the JMESPath expression itself, versus something else in the policy (webhook config, `match` scoping, and so on)?
*   **A)** Delete and recreate the ClusterPolicy repeatedly until it happens to work.
*   **B)** Extract the real `requiredSelector` and `metadata.labels` values into a small JSON file and run the same `label_match(...)` expression offline with `kyverno jp query`, entirely outside the cluster and the admission path.
*   **C)** Add `background: true` to the rule and wait for the next scheduled scan.
*   **D)** Increase the Kyverno controller's log verbosity and hope the JMESPath evaluation is logged verbatim.
</details>

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `kyverno jp query` lets you evaluate the exact same expression and Kyverno custom function against representative data completely offline, isolating whether the *expression itself* is wrong before you ever involve the cluster, the webhook pipeline, or `match`/`exclude` scoping — a much faster and more precise debugging loop than iterating against a live admission request.
*   **Why others are incorrect:**
    *   *Option A* is not debugging at all — it changes nothing about the expression and wastes cycles.
    *   *Option C* is unrelated to `preconditions` evaluation and doesn't isolate the JMESPath expression from other failure causes.
    *   *Option D* is a slower, less certain path than directly testing the expression offline, and controller logs are not guaranteed to include the exact evaluated JMESPath result.
</details>

---

## Audit and Review Key

Check your score and use this review matrix to trace any incorrect answers back to their exact section and module chapters:

| Question | Targeted Kyverno Competency | Review Chapter |
| :--- | :--- | :--- |
| **Q1** | Reproducible CLI installation methods | **[Section 010, Module 01](./section-010/module-01/course.md)** |
| **Q2** | Verifying an install & diagnosing PATH issues | **[Section 010, Module 01](./section-010/module-01/course.md)** |
| **Q3** | Offline `kyverno apply` with `--resource` | **[Section 020, Module 01](./section-020/module-01/course.md)** |
| **Q4** | `--cluster` scoping & `--policy-report` output | **[Section 020, Module 01](./section-020/module-01/course.md)** |
| **Q5** | Grouped `results` entries in `kyverno-test.yaml` | **[Section 030, Module 01](./section-030/module-01/course.md)** |
| **Q6** | Test coverage safeguards & CI exit codes | **[Section 030, Module 01](./section-030/module-01/course.md)** |
| **Q7** | `kyverno jp query` output formatting flags | **[Section 040, Module 01](./section-040/module-01/course.md)** |
| **Q8** | Debugging Kyverno custom JMESPath functions offline | **[Section 040, Module 01](./section-040/module-01/course.md)** |
