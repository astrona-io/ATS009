# Writing & Running Kyverno Test Suites

Astronaut, `kyverno apply` proves that a policy does the right thing *today*, against the resources you hand it. It does not stop someone from editing that policy tomorrow and quietly breaking the case you already checked. `kyverno test` closes that gap. You write a test manifest: a pre-flight checklist with the expected verdict next to every line, such as "this rule must clear this ship and turn that one away". The Kyverno command-line interface (CLI) runs the real checks, compares them with your checklist, and fails loudly the moment the two disagree. That makes it a natural step in a CI pipeline (continuous integration: the launch checklist every change must clear before it leaves the shipyard).

This module teaches you to write that checklist and to read what it tells you.

```mermaid
flowchart TB
    A["kyverno-test.yaml"] --> C["kyverno test ."]
    B["policies and resources"] --> C
    C --> D["real results"]
    D -->|"all match"| E["exit 0: PASS"]
    D -->|"any mismatch"| F["non-zero: FAIL"]
```

The test command runs the real check on your files and compares each result with the one your manifest expects; one mismatch is enough to fail the run.

## Learning objectives

After this module you can:

- Write a `kyverno-test.yaml` manifest that lists `policies`, `resources` and the expected `results`.
- Assert `pass`, `fail`, `skip` and `warn` correctly, and know when several resources can share one `results` entry.
- Name the rule correctly in a `results` entry for autogen rules, and test `foreach` and `deny` rules.
- Run a test suite from a local folder or a remote Git repository, and narrow a run with `--test-case-selector`.
- Read the output and the exit code of `kyverno test`, and decide whether a CI pipeline can rely on it.
- Explain why a suite that always passes, because someone edited it to match the tool's output, proves nothing.

## Before you start

This module is about the `kyverno` CLI and plain files on disk. No new cluster ideas come up.

### What you should already know

- **How a Kyverno `validate` rule works.** A `ClusterPolicy` is a page of the fleet rulebook. A `validate` rule with a `pattern` is a template the ship's papers must fit, and `match` says which ships the rule looks at.
- **How `kyverno apply` reports.** It checks a policy against resource files and reports `pass`, `fail`, `warn`, `error` or `skip` for each one.

### What is waiting in your playground

Your playground is a terminal with the `kyverno` CLI `1.13.2` and a practice folder, `~/kyverno-cli-lab`. The folder holds these files:

| File | What it is |
| --- | --- |
| `require-run-as-nonroot.yaml` | `ClusterPolicy` with rule `check-runAsNonRoot` |
| `good-pod.yaml` | A Pod that sets `runAsNonRoot: true` |
| `bad-pod.yaml` | A Pod with no `securityContext` |
| `web-deployment.yaml` | A Deployment named `web` |
| `no-privileged.yaml` | `ClusterPolicy` with the `foreach` and `deny` rule `check-privileged` |
| `privileged-pod.yaml` | A Pod with a privileged container |
| `calm-pod.yaml` | A Pod with no privileged container |

There is no cluster to set up and no test manifest yet: you write them. The graded mission at the end of the module uses its own cluster and folder.

## How this module is organised

1. **[Test Manifest Anatomy](./course-01-test-manifest-anatomy.md)**: the `kyverno-test.yaml` file: `policies`, `resources`, `results`, the optional `variables` and `userinfo` files, and when resources can share an entry.
2. **[Autogen Names, Foreach And Deny Rules](./course-02-autogen-names-foreach-and-deny.md)**: what the `rule` field must say for rules that Kyverno copies for Deployments, and how a `foreach` rule gives its verdict.
3. **[Running & Interpreting Test Results](./course-03-running-and-interpreting-test-results.md)**: running `kyverno test`, reading its table, the exit code, and wiring it into CI. It ends with your graded mission.
4. **[Summary](./course-04-summary.md)**: what you learned, your mission, questions to check yourself, and cleaning up.

## Why this matters

A policy change is safe to merge only when someone has checked that it still clears the right ships and turns away the right ones. Reading every YAML change by hand does not scale. A test suite does that check every time, in seconds, and its exit code is something a pipeline can act on.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
