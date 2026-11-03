# Overview: Mutate And Generate With apply (Playground)

This is a playground, not a lab. It starts a training solar system (a `kind` cluster) and waits. There is no task, no `astrona submit` and no pass or fail.

## What is in the box

- The `kyverno` CLI `1.13.2` in `/usr/local/bin`. Check it with `kyverno version`.
- A `kind` cluster with `kubectl` ready. It has no Kyverno controller, so no rule runs in the cluster. The namespace `apps` exists and is empty.
- Example resource files in `/root/apply-mutate/`:

  | File | What it is |
  | --- | --- |
  | `legacy-app.yaml` | A Pod in `apps` with no labels |
  | `compliant-app.yaml` | A Pod in `apps` with the label `team: checkout` |
  | `mars.yaml` | A `Namespace` called `mars`, to use as a generate trigger |

- No policy files: you write the policies as you read the course.

## Practice ideas

- Write a mutate policy that adds a label only when it is missing, and run it on both Pods. Compare the two results.
- Send the mutated Pod to a file with `-o`, create it with `kubectl apply -f`, and read its labels with `--show-labels`.
- Write a generate rule that builds a `ConfigMap` in every new `Namespace`, run it on `mars.yaml`, and read the file written by `-o`.
- Write a rule that denies everyone except one cluster role, and pass the role in with `-u`.
- Use `--set request.operation=DELETE` on a rule that reads `request.operation`.
