# Question

Solve this question on: `terminal`

Astronaut, your mission: make a pipeline gate behave. The `kyverno` CLI `1.13.2` is installed. The cluster has no Kyverno controller, so only the CLI runs the rules. The files are in `/root/apply-gate/`: `enforce-policy.yaml` (`require-team-label`, an `Enforce` policy that needs a `team` label on every Pod in `apps`), `audit-policy.yaml` (`require-team-label-audit`, the same rule in `Audit` mode), `legacy-app.yaml` (a Pod with no labels) and `compliant-app.yaml` (a Pod with `team: checkout`).

1.  `kyverno apply enforce-policy.yaml` on both Pod files fails today. Write a `PolicyException` file `/root/apply-gate/legacy-exception.yaml` that excuses only `legacy-app` from the rule `check-team-label` of the policy `require-team-label`, so the same command exits with code `0` when you add `-e /root/apply-gate/legacy-exception.yaml`. Do not edit `enforce-policy.yaml`.
2.  Run `audit-policy.yaml` on both Pod files with `--audit-warn` and `--warn-exit-code 3`. Save the exit code of that command to `/root/apply-gate/gate-exit-code.txt`.
3.  Run `audit-policy.yaml` on both Pod files with `--audit-warn` and `--table`. Save the screen output to `/root/apply-gate/gate-table.txt`.

The grader checks three things: your exception makes `enforce-policy.yaml` exit `0` while the policy still fails without it; `gate-exit-code.txt` holds `3`; and `gate-table.txt` lists `legacy-app` as a warning and `compliant-app` as a pass.
