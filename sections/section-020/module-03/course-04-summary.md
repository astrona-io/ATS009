# Summary

Well done, astronaut. Your dock guard can now excuse a ship, report with its own exit code, and show its results in the form each reader needs. Look back at what you learned, check yourself, and clean up.

## What you learned

**From [Exceptions With -e](./course-01-exceptions-with-policy-exceptions.md):**

- A `PolicyException` excuses named resources from named rules of a policy. Pass it with `-e`/`--exception`.
- `policyName`, `ruleNames` and `match` must fit. An excused resource is `skip`, not `pass`.
- Keep the `match` narrow.

**From [Warnings And Exit Codes](./course-02-warnings-and-exit-codes.md):**

- Any `fail` or `error` exits `1`, even for an `Audit` policy.
- `--audit-warn` turns `Audit` violations into warnings, and the exit code becomes `0`.
- `--warn-exit-code N` gives warnings the exit code `N`. Without `--audit-warn` it changes nothing.
- `--warn-no-pass` works together with `--warn-exit-code`.

**From [Reading The Results](./course-03-reading-the-results.md):**

- `--table` lists every resource. `--detailed-results` adds detail. `-p` prints a policy report.
- `--continue-on-fail` carries on with the next resource.
- The exit code is what a pipeline reads.

## Your mission

You proved the skill in a graded mission, right after the part that taught it:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Exceptions, Warnings & Exit Codes Lab](./labs/lab-01/README.md) | Reading The Results | write a `PolicyException`, set a warning exit code, and save a results table |

If you skipped it, go back to it now.

## Check yourself

<details>
<summary>1. An Enforce policy fails one Pod. You pass a correct exception with <code>-e</code>. What does that Pod count as?</summary>

A `skip`. It is excused, not checked. The exit code is `0` if nothing else fails.
</details>

<details>
<summary>2. You run an Audit policy that finds a violation. The exit code is <code>1</code>. Why, and how do you get <code>0</code>?</summary>

By default a violation counts as a failure, even in Audit mode. Add `--audit-warn` and it becomes a warning, which exits `0`.
</details>

<details>
<summary>3. You add <code>--warn-exit-code 3</code> and still get <code>1</code>. What is missing?</summary>

`--audit-warn`. With no warnings, the failure wins and the code is `1`.
</details>

<details>
<summary>4. Which output lists every resource, passing ones included, as rows?</summary>

`--table`.
</details>

<details>
<summary>5. A pipeline step reads <code>kyverno apply ... ; echo done</code> and is always green. Why?</summary>

The step's exit code is the code of `echo`. Make `apply` the last command or chain with `&&`.
</details>

## Clean up

The playground is a whole Kubernetes cluster running on your machine. Remove it, and any mission that is still running.

```sh
astrona list
```

If the playground or a mission is still listed, remove it. The command takes the **name**, not the folder path:

```sh
astrona destroy ats-009-playground-020-03
```

> *Excuse the old ship in writing, give warnings their own number, and read the log in the form you need.*

<!-- astrona:playground:destroy -->
