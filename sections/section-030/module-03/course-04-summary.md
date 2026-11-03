# Summary

A test suite for real policies needs more than a policy and a resource. It needs the facts the policy would ask for, the identity of the requester and the waivers that apply. Once those are files, the suite can grow, and folders keep it readable.

## What you learned

**[Variables And User Info](./course-01-variables-and-user-info.md):**

- Policy variables come from `context` entries. A `Values` file, named in the `variables` field, supplies them. The variable name is the context entry name plus the path into the data.
- A missing variable makes the run report an error, not a plain wrong verdict.
- A `UserInfo` file, named in the `userinfo` field, sets the requester's cluster roles and user name. A rule that depends on the requester needs one test for each badge.

**[Exceptions And Skip Results](./course-02-exceptions-and-skip-results.md):**

- The `exceptions` field lists `PolicyException` files. An excepted resource gets the claim `skip`.
- Always add a resource without a waiver and claim `fail`, to prove the waiver is narrow.
- `skip` has four causes: no match, an exclude, a false precondition and an exception. The result word is the same, so names must explain.

**[Organising Large Test Suites](./course-03-organising-large-test-suites.md):**

- Keep inputs in shared folders and one `kyverno-test.yaml` for each scenario. Paths are relative to the manifest.
- `kyverno test .` finds every `kyverno-test.yaml` below the folder and gives one summary and one exit code.
- `--test-case-selector` narrows a run while you debug. It does not belong in the gate.
- On `1.13.2`, an empty folder exits `0`, so a pipeline must check that manifests exist.

## Your mission

You proved the skill in a graded mission, right after the part that taught it:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Variables, Exceptions And Suites Lab](./labs/lab-01/README.md) | Organising Large Test Suites | write three suites in three folders, with a variable, an exception and two badges, and run them together |

If you skipped it, go back to it now.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. A policy uses <code>{{ registryConfig.data.prefix }}</code>. Where does an offline test get its value?</summary>

From a `Values` file named in the `variables` field of the manifest. The variable name must be the context entry name plus the path into the data.
</details>

<details>
<summary>2. You forget the <code>variables</code> line. What does the run show?</summary>

An error for the affected rules, because the rule cannot fill in its placeholder. It is not a plain `Want pass, got fail`.
</details>

<details>
<summary>3. The same Pod is let through for an admin and turned away for a developer. How do you test both?</summary>

Write two manifests, each with its own `userinfo` file. One claims `skip` and the other claims `fail`.
</details>

<details>
<summary>4. A suite has an exception for <code>legacy-pod</code> and claims <code>skip</code>. Which other test do you add?</summary>

A Pod without a waiver, with the claim `fail`. It proves that the waiver frees only the Pod it names.
</details>

<details>
<summary>5. A manifest is in <code>tests/registry</code>. How does it point to <code>policies/restrict-registry.yaml</code>?</summary>

`../../policies/restrict-registry.yaml`. Paths are relative to the folder of the manifest.
</details>

<details>
<summary>6. Your pipeline runs <code>kyverno test .</code> on <code>1.13.2</code> and someone deleted all manifests. What happens?</summary>

The CLI reports `No test yamls available` and exits `0`, so the pipeline is green. Add a check that at least one `kyverno-test.yaml` exists.
</details>

## Clean up

Remove the playground and the mission when you are done. See what is still running first:

```sh
astrona list
```

Remove the playground by its **name**:

```sh
astrona destroy ats-009-playground-030-03
```

If the mission is still listed, remove it the same way:

```sh
astrona destroy ats-009-lab-013
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *A suite is only as good as its inputs and its order. Supply the facts, name the waivers, and keep the folders tidy.*

<!-- astrona:playground:destroy -->
