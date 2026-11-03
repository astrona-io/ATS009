# Overview: Exceptions, Warnings And Exit Codes (Playground)

This is a playground, not a lab. It starts a training solar system (a `kind` cluster) and waits. There is no task, no `astrona submit` and no pass or fail.

## What is in the box

- The `kyverno` CLI `1.13.2` in `/usr/local/bin`. Check it with `kyverno version`.
- A `kind` cluster with `kubectl` ready. It has no Kyverno controller. The namespace `apps` exists and is empty.
- Two example Pod files in `/root/apply-gate/`:

  | File | What it is |
  | --- | --- |
  | `legacy-app.yaml` | A Pod in `apps` with no labels |
  | `compliant-app.yaml` | A Pod in `apps` with the label `team: checkout` |

- No policy files: you write the policies as you read the course.

## Practice ideas

- Write a policy that requires a `team` label, once with `Enforce` and once with `Audit`, and compare the exit codes.
- Write a `PolicyException` for `legacy-app` and pass it with `-e`.
- Run the Audit policy with `--audit-warn`, then add `--warn-exit-code 3`, and read `echo $?` each time.
- Add `--table`, `--detailed-results` and `-p` and compare what each one prints.
