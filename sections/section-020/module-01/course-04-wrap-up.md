# Wrap-Up: Mission Debrief

Well done, astronaut. You can now test a rule on paper, answer its questions for it, and audit a live solar system without changing a thing. Before you move on, look back at what you learned, check yourself, and clean up.

## What you learned

This module was about one command, `kyverno apply`, and the three ways you feed it.

**From [Offline Policy Apply](./course-01-offline-policy-apply.md):**

- By default, `kyverno apply` needs no cluster. It checks a policy against resource files passed with `--resource` (`-r`), one flag per file, or a whole folder.
- The default output lists only the failing resources, then a summary line: `pass`, `fail`, `warn`, `error`, `skip`. `--table` lists every resource but no summary line.
- `error` means the CLI could not finish the check. It is not the same as `fail`.
- "3 policy rule(s)" for a one-rule Pod policy comes from autogen rules for Deployments and CronJobs.
- Any `fail` or `error` gives a non-zero exit code. That is what makes `apply` a CI gate.

**From [Supplying Variables With A Values File](./course-02-supplying-variables-with-a-values-file.md):**

- Variables come from `request.*`, `element`, `images.*` or the rule's own `context` entries.
- Offline, a `configMap` or `apiCall` lookup has nobody to ask, so the result is `error`.
- A values file (`-f`/`--values-file`) or `--set` supplies the missing value. For a `configMap` lookup, the key is the full path, such as `approvedRegistry.data.registry`.
- A mock cannot invent a new variable name, and it does not beat a computed `variable` context entry.

**From [Applying Against a Live Cluster & Policy Reports](./course-03-applying-against-a-live-cluster-and-policy-reports.md):**

- `--cluster` (`-c`) reads live resources from your current `kubeconfig` context, read-only. `-n`/`--namespace` limits it to one namespace.
- `--policy-report` (`-p`) prints a `ClusterPolicyReport` with every result, passing ones included. Redirect it to a file to keep it.
- Audit with `--cluster` before you `kubectl apply` a new policy.
- Once applied, an `Enforce` policy blocks new resources at admission. Resources that already existed keep running.

## Your mission

You proved the skill in a graded mission, right after the part that taught it:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Offline & Cluster Policy Apply Lab](./labs/lab-01/README.md) | Applying Against a Live Cluster & Policy Reports | check a policy offline, audit a live namespace with a report, and see real enforcement on a new Pod |

If you skipped it, go back to it now. The exam asks for exactly these skills.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. You have no <code>kubeconfig</code> on this machine. Can you still test a draft policy against a Pod file?</summary>

Yes. `kyverno apply policy.yaml --resource pod.yaml` runs completely offline. Only `--cluster` needs a cluster.
</details>

<details>
<summary>2. An offline run shows <code>error: 2</code> and no passes or fails. The policy has a <code>configMap</code> context entry. What is missing?</summary>

The value of the lookup. Offline, the CLI cannot read the `ConfigMap`. Supply it with `-f values.yaml` or `--set`, using the full path the rule reads.
</details>

<details>
<summary>3. Your pipeline step runs <code>kyverno apply ... ; echo done</code> and always shows green. Why?</summary>

The step's exit code is the exit code of the last command, `echo`. Let `kyverno apply` be the last command of the step, or chain with `&&`, so its non-zero exit code stops the pipeline.
</details>

<details>
<summary>4. Does <code>kyverno apply policy.yaml --cluster -n orders</code> change anything in the namespace?</summary>

No. It only reads the live resources and reports. Nothing changes until you apply the policy with `kubectl`.
</details>

<details>
<summary>5. You applied an <code>Enforce</code> policy that requires a <code>team</code> label. An old Pod without the label is still running. Is the policy broken?</summary>

No. Admission checks run only when a resource is created or changed. The old Pod was admitted before the policy existed. A new Pod without the label is rejected.
</details>

## Clean up

Each mission is a whole Kubernetes cluster running on your machine. When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

If the mission is still listed, remove it. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-009-lab-003
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *Test on paper first, answer the scanner's questions with a values file, then audit the live planet before you switch a rule on.*
