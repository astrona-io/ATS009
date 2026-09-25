# Section 040 Knowledge Check: kyverno jp

Test your understanding of JMESPath fundamentals, the real `kyverno jp query` flags, literal syntax, and Kyverno's custom JMESPath functions.

---

## Scenario-Based Questions

### Question 1
You run `kyverno jp query -i pod.json 'metadata.name'` with no other flags and get back `"checkout-web-7f8c9"` — quotes included. Which flag makes the same query print `checkout-web-7f8c9` without the surrounding quotes?
*   **A)** `-c` / `--compact`
*   **B)** `-u` / `--unquoted`
*   **C)** `-q` / `--query`
*   **D)** There is no such flag; you must pipe the output through a tool like `tr` to strip the quotes.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `-u`/`--unquoted` is exactly what it says — if the final result is a string, it prints without the JSON `"quotes"` that wrap it by default.
*   **Why others are incorrect:**
    *   *Option A* controls JSON whitespace compactness, not quoting.
    *   *Option C* reads the query expression itself from a file — unrelated to output formatting.
    *   *Option D* describes a workaround that exists only because you're not using the flag that already does this.
</details>

---

### Question 2
You want to test the expression `metadata.labels.team == 'checkout'` without editing a policy file. What are the two supported ways to get the input JSON/YAML document into `kyverno jp query`?
*   **A)** Only `-i <file>` — stdin is not supported.
*   **B)** Only piping via stdin — `-i` is not supported.
*   **C)** Either `-i <file>` or piping the document in via stdin.
*   **D)** Neither; the document must be pasted directly into the expression string.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: C**

*   **Why C is correct:** `kyverno jp query` accepts the input document either as a file via `-i`/`--input`, or piped in from stdin (`cat object.yaml | kyverno jp query -q query-file`) — and the same is true for the query expression itself, which can come from the command line, a file via `-q`, or stdin.
*   **Why others are incorrect:** Both A and B each describe only one of the two supported input paths. D isn't how the tool works at all — the document and the expression are always separate inputs.
</details>

---

### Question 3
Which of these is the correct way to write the string literal `checkout` as a raw string inside a JMESPath expression evaluated by `kyverno jp`?
*   **A)** `` `checkout` `` (backticks around the bare word)
*   **B)** `'checkout'` (single quotes)
*   **C)** `"checkout"` (double quotes)
*   **D)** `` `"checkout"` `` (backticks around a double-quoted word) — and this is the *only* valid form.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** JMESPath's raw string literal syntax is single quotes — `'checkout'` — and this is the simplest, correct way to write a bare string literal for comparisons like `name == 'checkout'`.
*   **Why others are incorrect:**
    *   *Option A* is invalid: a backtick literal must contain valid JSON, and the bare word `checkout` (unquoted) is not valid JSON.
    *   *Option C* is not JMESPath literal syntax at all.
    *   *Option D* is actually also valid (a JSON-string-inside-backticks) but it is not the *only* valid form, and it is needlessly more verbose than the single-quoted raw string — making the claim in D false.
</details>

---

### Question 4
Before using a Kyverno custom JMESPath function you haven't used before, what is the recommended first step this module teaches, and why?
*   **A)** Guess the argument order based on the function's name and test it against production data.
*   **B)** Run `kyverno jp function <name>` to see its exact signature and description for your installed CLI version.
*   **C)** Search a third-party blog post, since Kyverno's own CLI has no introspection for this.
*   **D)** Assume it behaves identically to a same-named function from the `jq` or stock `jp` tools.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `kyverno jp function <name>` is the CLI's own live reference for a custom function's exact behavior, and it is guaranteed to match the exact version installed — the single most reliable source, faster than searching docs.
*   **Why others are incorrect:**
    *   *Option A* is risky and exactly the kind of guesswork this module teaches you to avoid.
    *   *Option C* ignores that the CLI already ships this introspection built in.
    *   *Option D* is a dangerous assumption — Kyverno's custom functions are Kyverno-specific and are not part of the stock JMESPath spec or any other tool's function set.
</details>

---

### Question 5
You need to check whether a container image string matches `registry.example.com/team/*` and you also separately need to validate that an annotation looks like a well-formed email address using a full regular expression. Which two functions do you reach for, respectively?
*   **A)** `regex_match` for the glob, `pattern_match` for the email check.
*   **B)** `pattern_match` for the glob, `regex_match` for the email check.
*   **C)** `pattern_match` for both — it supports full regex syntax too.
*   **D)** `regex_match` for both — it also supports simple glob wildcards.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `pattern_match` is Kyverno's simple, non-regex glob match (`*` as a wildcard, nothing more) — right for the image-path check. `regex_match` runs a full regular expression — right for validating the email shape, which glob wildcards can't express.
*   **Why others are incorrect:** A reverses the two. C and D each claim one function does double duty as the other, which is exactly the mix-up this module's common pitfall warns against — using the wrong one doesn't error, it just silently evaluates incorrectly.
</details>

---

### Question 6
A colleague writes a Kyverno `ClusterPolicy` `preconditions` block using `label_match(requiredSelector, request.object.metadata.labels)`, but the rule isn't behaving as expected in the cluster. What is the fastest way to isolate whether the problem is the JMESPath expression itself, versus something else in the policy (webhook config, `match` scoping, etc.)?
*   **A)** Add more `kubectl describe` output to the ticket and wait for a teammate to spot the issue.
*   **B)** Save a representative JSON payload (or the actual `AdmissionReview`/resource) to a file and run the exact same expression through `kyverno jp query -i <file> -u 'label_match(requiredSelector, request.object.metadata.labels)'` to see precisely what it evaluates to, independent of the cluster.
*   **C)** Set `validationFailureAction` to `Audit` and hope the `PolicyReport` explains the JMESPath result.
*   **D)** Rewrite the expression from scratch using a different function, since the exact expression can't be tested outside a live policy.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** This is the entire point of `kyverno jp` — it runs the exact same JMESPath engine Kyverno uses in-cluster, so testing the identical expression against a representative payload isolates whether the expression itself is wrong, without any cluster round-trip.
*   **Why others are incorrect:**
    *   *Option A* doesn't actually test the expression at all.
    *   *Option C* might show *that* something is failing, but not *why* the expression itself evaluates the way it does.
    *   *Option D* is false — this module's entire premise is that you can and should test the exact expression offline first.
</details>
