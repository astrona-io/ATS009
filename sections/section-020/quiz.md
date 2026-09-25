# Section 020 Knowledge Check: kyverno apply

Test your understanding of offline policy apply, values files and `--set`, reading the pass/fail/warn/error/skip summary, `--cluster` scoping, and generating a `PolicyReport`.

---

## Scenario-Based Questions

### Question 1
You want to check whether a new policy would pass against a resource manifest you're still drafting, and you have no `kubeconfig` configured at all on this machine. Which command lets you do this?
*   **A)** `kubectl apply --dry-run=server -f policy.yaml`
*   **B)** `kyverno apply policy.yaml --resource resource.yaml`
*   **C)** `kyverno apply policy.yaml --cluster`
*   **D)** `kyverno test policy.yaml --resource resource.yaml`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `kyverno apply` with `-r`/`--resource` evaluates a policy against local resource files entirely offline — no cluster, no `kubeconfig`, nothing installed. This is exactly the scenario of testing a draft manifest before a cluster is even involved.
*   **Why others are incorrect:**
    *   *Option A* requires a live API server to dry-run against, which the question rules out.
    *   *Option C* requires `--cluster`, which needs a working `kubeconfig` pointed at a real cluster.
    *   *Option D* names the wrong subcommand — `kyverno test` runs a `kyverno-test.yaml` test suite with declared expected results, not an ad-hoc apply against arbitrary files (covered in Section 030).
</details>

---

### Question 2
You run `kyverno apply policy.yaml --resource pod.yaml` and the summary line reads `pass: 0, fail: 0, warn: 0, error: 1, skip: 0`. What does this tell you, as distinct from a `fail: 1` result?
*   **A)** The Pod violated the policy and would have been rejected under Enforce.
*   **B)** The policy's `match` block excluded this Pod, so the rule never ran.
*   **C)** Kyverno could not finish evaluating the rule at all — for example, an unresolved policy variable — which is a different problem than a legitimate pass/fail verdict.
*   **D)** The policy passed, but with a deprecation warning about its API version.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: C**

*   **Why C is correct:** `error` means the engine couldn't complete evaluation — most commonly because a variable the policy references (e.g. from `context` or a template expression) was never supplied via `-f`/`--values-file` or `--set` when running offline. It is deliberately counted separately from `fail`, because it means "I don't know the answer," not "the answer is no."
*   **Why others are incorrect:**
    *   *Option A* describes `fail`, not `error`.
    *   *Option B* describes `skip`.
    *   *Option D* describes `warn`, and isn't what `error` represents.
</details>

---

### Question 3
A `validate` rule's `pattern` references `{{ requiredTeam }}`, a custom variable with no default. You run `kyverno apply policy.yaml --resource pod.yaml` with no `-f` and no `--set`. What happens?
*   **A)** Kyverno treats the missing variable as an empty string and the rule evaluates normally.
*   **B)** The CLI prompts interactively for the missing value.
*   **C)** The policy is skipped for that resource and reported as an `error`, because a required variable was never provided.
*   **D)** `kyverno apply` automatically pulls the value from the live cluster, even in offline mode.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: C**

*   **Why C is correct:** When running offline, there's no live `AdmissionRequest` to source variables from — the CLI needs them supplied explicitly via `-f`/`--values-file` or `--set`. Without them, the policy can't be fully evaluated for that resource and the run reports an `error`, not a silent pass.
*   **Why others are incorrect:**
    *   *Option A* would produce misleading results and is not how the CLI behaves.
    *   *Option B* — the CLI is non-interactive by design, which is exactly what makes it usable in CI.
    *   *Option D* is wrong — offline mode by definition doesn't reach out to a cluster; that's what `--cluster` is for.
</details>

---

### Question 4
You want to see what would currently fail across your `orders` namespace if you enforced a brand-new policy, without creating, modifying, or admitting anything. Which command achieves this?
*   **A)** `kubectl apply -f policy.yaml -n orders --dry-run=client`
*   **B)** `kyverno apply policy.yaml --cluster --namespace orders`
*   **C)** `kyverno test policy.yaml --namespace orders`
*   **D)** `kyverno apply policy.yaml --resource ./orders-resources/`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `--cluster` makes `apply` fetch live resources from your current `kubeconfig` context instead of local files, and `-n`/`--namespace` scopes that to `orders`. This is a purely read-only evaluation against real, already-existing objects — exactly the "would this break anything if I enforced it right now" check.
*   **Why others are incorrect:**
    *   *Option A* validates the policy object itself against the API server's schema/admission chain, not "what would this policy do to existing resources in orders" — a client-side dry-run doesn't retroactively evaluate other objects.
    *   *Option C* — `kyverno test` runs a declared test suite, not an ad-hoc scan of a live namespace.
    *   *Option D* only evaluates resources you've exported to local files, not whatever is actually live in `orders` right now.
</details>

---

### Question 5
You run `kyverno apply policy.yaml --cluster --namespace orders --policy-report`. What does this produce, compared to the plain default output?
*   **A)** Identical plain-text output; `--policy-report` only changes the exit code behavior.
*   **B)** A `ClusterPolicyReport`-shaped YAML object with a `results` list and a `summary` block, instead of a human-readable text summary.
*   **C)** The mutated version of every matching resource, written to a `PolicyReport` directory.
*   **D)** A live `PolicyReport` object is created directly in the cluster.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `-p`/`--policy-report` changes the *shape* of `apply`'s output from a plain-text summary to a `ClusterPolicyReport` object (`apiVersion: wgpolicyk8s.io/v1alpha2`) printed to stdout, with a `results` entry per resource/rule and a `summary` block — the same report format Kyverno's own background-scanning controller writes into a cluster, generated here client-side.
*   **Why others are incorrect:**
    *   *Option A* is wrong — the output format genuinely changes, not just the exit code.
    *   *Option C* confuses `--policy-report` with `-o`, which writes out *mutated/generated* resources — an entirely different flag for an entirely different purpose.
    *   *Option D* is wrong — `kyverno apply` never writes anything back to the cluster; the report is generated and printed locally, not persisted as a cluster object.
</details>

---

### Question 6
A CI pipeline runs `kyverno apply policy.yaml --resource ./manifests/ ; echo "step finished"` and always reports success, even when a manifest clearly violates the policy. What is the most likely cause?
*   **A)** `kyverno apply` never returns a non-zero exit code, regardless of results.
*   **B)** The pipeline step's shell is discarding `kyverno apply`'s exit status (for example, by unconditionally running a following command with `;` instead of checking `$?`), so a real `fail`/`error` result never breaks the build.
*   **C)** `--resource` pointed at a directory instead of individual files, which silently disables failure reporting.
*   **D)** The policy needs `--warn-exit-code` set before failures can affect the exit code at all.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `kyverno apply` does exit non-zero when any resource fails or errors — that's what makes it usable as a CI gate. But `cmd1 ; cmd2` always runs `cmd2` regardless of `cmd1`'s exit status, and if nothing downstream inspects `$?`, the pipeline step's own final exit code reflects `echo`, not `kyverno apply`. The fix is to let the failing command's exit code propagate (e.g. run it as its own step, or use `&&` and check `$?` explicitly).
*   **Why others are incorrect:**
    *   *Option A* is factually wrong — a `fail`/`error` result does produce a non-zero exit code by default.
    *   *Option C* — pointing `--resource` at a directory is fully supported and doesn't change exit-code behavior.
    *   *Option D* is backwards — `--warn-exit-code` customizes the exit code used for *warnings* specifically; ordinary failures already cause a non-zero exit without it.
</details>
