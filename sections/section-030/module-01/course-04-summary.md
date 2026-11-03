# Summary

`kyverno test` turns a one-time check into a standing claim. A test manifest states what each rule must decide about each resource, and a run compares those claims with what Kyverno really decides. A mismatch fails the run, and the exit code tells a pipeline what to do.

## What you learned

**[Test Manifest Anatomy](./course-01-test-manifest-anatomy.md):**

- A `kyverno-test.yaml` (`apiVersion: cli.kyverno.io/v1alpha1`, `kind: Test`) lists `policies`, `resources` and `results`. It is for the CLI only and is never applied to a cluster.
- Optional `variables` and `userinfo` files supply variable values and the requester's identity.
- A `results` entry names a `policy`, a `rule`, resource **names**, a `kind` and the expected `result`: `pass`, `fail`, `skip` or `warn`.
- In the output, `Pass` means "the real verdict matched the claim", even for a Pod that really fails the rule.
- Resources can share one entry only when they really share the verdict. One mismatch fails the whole entry.
- Never make a suite pass by deleting the case that disagrees.

**[Autogen Names, Foreach And Deny Rules](./course-02-autogen-names-foreach-and-deny.md):**

- For a Deployment, the `rule` in a `results` entry is `autogen-` plus the original rule name, and the `kind` is `Deployment`.
- `-f` picks a manifest by file name, so one folder can hold more than one suite.
- A `foreach` rule with a `deny` block gives one verdict per resource: one bad item makes the whole resource `fail`.

**[Running & Interpreting Test Results](./course-03-running-and-interpreting-test-results.md):**

- `kyverno test .` runs the `kyverno-test.yaml` in a folder. A Git URL with `--git-branch` runs a suite from a repository.
- A mismatch shows as `Fail` with a reason such as `Want pass, got fail`, is repeated under "Aggregated Failed Test Cases", and gives a non-zero exit code.
- `--detailed-results` adds each rule's message. `--test-case-selector` narrows a run while you debug.
- The exit code is the CI gate: `0` only when every claim matches.
- An empty folder prints `No test yamls available` and still exits `0` in 1.13.2. Newer CLIs add `--require-tests`, `-o junit` and `--warnings-as-errors`; 1.13.2 does not have them.

## Your mission

You proved the skill in a graded mission, right after the part that taught it:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Kyverno Test Suite Lab](./labs/lab-01/README.md) | Running & Interpreting Test Results | find the wrong claim in a test manifest and fix it so each resource asserts its real result |

If you skipped it, go back to it now. The exam asks for exactly this skill.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. A <code>results</code> entry lists <code>good-pod</code> and <code>bad-pod</code> with <code>result: pass</code>. <code>bad-pod</code> really fails the rule. What does the run report?</summary>

A failure for `bad-pod`, with the reason `Want pass, got fail`, and a non-zero exit code. Grouping does not average out: one disagreeing resource is enough.
</details>

<details>
<summary>2. The table shows <code>Pass</code> for <code>bad-pod</code>, a Pod that breaks the rule. Is something wrong?</summary>

No. `RESULT` in `kyverno test` output says whether the claim matched. If the manifest expected `fail` for `bad-pod`, the test passes.
</details>

<details>
<summary>3. In a <code>results</code> entry, do you write <code>bad-pod</code> or <code>bad-pod.yaml</code>?</summary>

`bad-pod`. Inside `results`, `resources` takes the resource's `metadata.name`. File paths belong in the top-level `resources` list.
</details>

<details>
<summary>4. Which <code>rule</code> name does a results entry for a Deployment use, when the policy rule is called <code>check-runAsNonRoot</code>?</summary>

`autogen-check-runAsNonRoot`, with `kind: Deployment`. Kyverno writes that copy of the rule for Deployments, and it reports the copy under that name.
</details>

<details>
<summary>5. Someone deletes every hard case from a suite, and CI stays green. What would catch that?</summary>

A run that fails when no test cases are found. Newer CLIs have `--require-tests` for that. On 1.13.2, which reports `No test yamls available` with exit code `0`, the pipeline itself must check that the test files and cases are there.
</details>

<details>
<summary>6. You test a suite from a feature branch on GitHub, without <code>--git-branch</code>. Which branch is tested?</summary>

The repository's default branch, not your feature branch. Pass `--git-branch` explicitly.
</details>

## Clean up

Your playground and any mission are whole environments running on your machine. When you are done with this module, remove them.

First, see what is still running:

```sh
astrona list
```

Remove the playground. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-009-playground-030-01
```

If the mission is still listed, remove it the same way:

```sh
astrona destroy ats-009-lab-005
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *A test manifest is a claim about what Kyverno must decide. Fix the claim or the policy when they disagree, never the evidence.*

<!-- astrona:playground:destroy -->
