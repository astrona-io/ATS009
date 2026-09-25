# Part 2 — Applying Against a Live Cluster & Policy Reports

> Prerequisite: [Part 1 — Offline Policy Apply](./course-01-offline-policy-apply.md). Next: [Section 020 Knowledge Check](../quiz.md).

## From local files to live objects

Offline apply is perfect for resources you're drafting, but the most valuable question is often different: *"if I turned this policy on right now, what in my cluster would already be out of compliance?"* That's what `--cluster` (short form `-c`) is for — instead of reading local resource files, `apply` fetches matching resources directly from the cluster your `kubeconfig` currently points at:

```sh
kyverno apply policy.yaml --cluster
```

This never creates, modifies, or admits anything — it's still a read-only evaluation, just against live objects instead of files on disk. It's the safest possible way to answer "would this policy break anything if I applied it for real?" before you ever run `kubectl apply -f policy.yaml`.

> [!TIP]
> **Try it — audit before you enforce**
>
> A very common real-world sequence: write a policy, run `kyverno apply policy.yaml --cluster` against production to see what would currently fail, fix or exempt those resources first, *then* actually apply the policy live. Skipping this step is how a well-intentioned policy takes down a production namespace on day one.

## Scoping with `--namespace`

Without scoping, `--cluster` mode can evaluate resources across every namespace your credentials can see. Narrow it with `-n`/`--namespace`:

```sh
kyverno apply policy.yaml --cluster -n orders
```

## Generating a policy report

By default, `apply` prints its plain-text pass/fail summary. Add `--policy-report` (short form `-p`) to instead produce a YAML `ClusterPolicyReport` object on stdout — the same report shape Kyverno's own background-scanning controller writes into a cluster (`apiVersion: wgpolicyk8s.io/v1alpha2`), but generated here client-side from your `apply` run:

```sh
kyverno apply policy.yaml --cluster -n orders --policy-report
```

```yaml
apiVersion: wgpolicyk8s.io/v1alpha2
kind: ClusterPolicyReport
metadata:
  creationTimestamp: null
  name: merged
results:
  - message: "validation error: ... rule check-team-label failed at path /metadata/labels/"
    policy: require-team-label
    resources:
      - apiVersion: v1
        kind: Pod
        name: no-team-pod
        namespace: default
    result: fail
    rule: check-team-label
    scored: true
    source: kyverno
summary:
  error: 0
  fail: 1
  pass: 1
  skip: 0
  warn: 0
```

This is a structured, machine-parseable result you can redirect to a file and pipe into other tooling — a CI step that fails a build on any `fail` entries in the report, for instance, or a dashboard that ingests it directly:

```sh
kyverno apply policy.yaml --cluster -n orders --policy-report > report.yaml
```

## Putting it together

The full arc of this command across both parts of this module:

1. Draft a policy, test it offline against a couple of representative local resource files (Part 1).
2. Once you trust the rule logic, point the same command at your real cluster with `--cluster -n <namespace>` to see what's currently non-compliant.
3. Generate a `--policy-report` for that audit so the result is structured and shareable, not just terminal output you have to read by eye.
4. Only then apply the policy for real with `kubectl apply -f policy.yaml`.

## Reference

- `kyverno apply --help` — confirm exact flag spelling for your installed version.
- [`kyverno apply` reference](https://kyverno.io/docs/kyverno-cli/reference/kyverno_apply/) — official documentation.
