# Question

Solve this question on: `terminal`

Astronaut, your mission: use `kyverno apply` to preview a mutation and a generation, pass in a user identity, and send the repaired ship to the cluster. The `kyverno` CLI `1.13.2` is installed. The namespace `apps` exists and has no Pods. The cluster has no Kyverno controller, so only the CLI can run the rules. The files are in `/root/mutate-lab/`: `mutate-policy.yaml` (`default-tier-label`, a mutate rule that adds the label `tier: standard` when a Pod has no `tier` label), `scout.yaml` (a Pod), `generate-policy.yaml` (`planet-welcome`, a generate rule triggered by a `Namespace`), `venus.yaml` (a `Namespace`) and `bridge-policy.yaml` (`bridge-access`, which lets only the cluster role `bridge-officer` through).

1.  Run `kyverno apply` with `mutate-policy.yaml` on `scout.yaml` and write the mutated Pod to `/root/mutate-lab/scout-mutated.yaml` with `-o`. Do not change `scout.yaml`.
2.  Run `kyverno apply` with `generate-policy.yaml` on `venus.yaml` and write the generated resource to `/root/mutate-lab/welcome-generated.yaml` with `-o`.
3.  `kyverno apply bridge-policy.yaml --resource scout.yaml` fails today. Write a user info file `/root/mutate-lab/bridge-officer.yaml` that makes the same command exit with code `0` when you add `-u /root/mutate-lab/bridge-officer.yaml`. Do not edit `bridge-policy.yaml`.
4.  Create the mutated Pod in the cluster with `kubectl`, so that Pod `scout` runs in `apps` with the label `tier=standard`.

The grader checks four things: `scout-mutated.yaml` holds the Pod with `tier: standard` and the old label `app: scout`, and `scout.yaml` is unchanged; `welcome-generated.yaml` holds a `ConfigMap` named `welcome` in the namespace `venus`; your user info file makes `bridge-access` exit `0` while the policy still fails without it; and the live Pod `scout` has the label `tier=standard`.
