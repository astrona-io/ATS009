# Summary

A mutate or generate rule does work, so its test must describe the work. `kyverno test` builds the real patched or generated resource and compares it with a file you wrote. A difference of one value fails the run.

## What you learned

**[Testing Mutate Rules](./course-01-testing-mutate-rules.md):**

- A mutate `results` entry has `result: pass` and a `patchedResources` file. The file holds the whole resource, as it must look after the rule ran.
- `result: skip` claims that the rule does not apply to a resource. It breaks the moment the resource starts to match.
- The reason `Resource diff` means the rule ran but its output differs from your file. Decide first which side is wrong: the file or the policy.

**[Testing Generate Rules](./course-02-testing-generate-rules.md):**

- For a generate rule, `resources` and `kind` name the **trigger**, such as a Namespace. The `generatedResource` file holds the **output**, such as a NetworkPolicy.
- The expected file carries the new resource's namespace, because the policy takes it from the trigger.
- A clone rule needs `cloneSourceResource`, a file with the resource to copy, because the offline test has no cluster to read from.

## Your mission

You proved the skill in a graded mission, right after the part that taught it:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Mutate And Generate Test Lab](./labs/lab-01/README.md) | Testing Generate Rules | write the expected files and one test manifest that covers a mutate pass, a mutate skip and a generated resource |

If you skipped it, go back to it now.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. A mutate rule adds a label. What does the <code>results</code> entry need besides <code>result: pass</code>?</summary>

A `patchedResources` entry that points to a file with the whole patched resource. Without it, the test only says that the rule ran, not what it changed.
</details>

<details>
<summary>2. The reason column says <code>Resource diff</code>. Is the policy broken?</summary>

Not necessarily. It says that the resource the rule produced differs from your expected file. The policy may have changed, or the file may be wrong. Compare both before you fix either.
</details>

<details>
<summary>3. A mutate rule does not match a Pod because of its label selector. Which result do you write for that Pod?</summary>

`skip`. The rule does not apply to the Pod, and the claim fails if the Pod starts to match.
</details>

<details>
<summary>4. In a generate test, which resource name goes into <code>resources</code>: the Namespace or the generated NetworkPolicy?</summary>

The Namespace, the trigger. The NetworkPolicy goes into the `generatedResource` file.
</details>

<details>
<summary>5. Why does a clone rule test need <code>cloneSourceResource</code>?</summary>

A clone rule copies an existing resource. The offline test has no cluster to read it from, so you hand it the source as a file.
</details>

## Clean up

Remove the playground and the mission when you are done. See what is still running first:

```sh
astrona list
```

Remove the playground by its **name**:

```sh
astrona destroy ats-009-playground-030-02
```

If the mission is still listed, remove it the same way:

```sh
astrona destroy ats-009-lab-012
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *A mutate or generate test is a picture of the result. Keep the picture and the policy in step.*

<!-- astrona:playground:destroy -->
