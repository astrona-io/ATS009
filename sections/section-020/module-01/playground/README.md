# Applying Policies with the Kyverno CLI - Playground

- **Slug:** ats-009-playground-020-01
- **Type:** Astrona playground - clean environment, no task, no grading

A `kind` cluster with the Kyverno controller `v1.13.2` and the `kyverno` CLI
`1.13.2` in `/usr/local/bin`. The namespace `apps` has two running Pods,
`compliant-app` (label `team: checkout`) and `legacy-app` (no `team` label).
The example files are in `/root/apply-lab/`. The policy is not applied to the
cluster. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-009-playground-020-01
```

`astrona destroy` takes the environment name (`metadata.name`), not the path.
`astrona submit` and `astrona test` do not apply: there is no grading.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `bootstrap/01-install-kyverno.sh` | Installs the Kyverno controller v1.13.2 |
| `bootstrap/02-install-kyverno-cli.sh` | Installs the CLI v1.13.2 |
| `bootstrap/03-setup-apply-playground.sh` | Creates `apps`, the two Pods and the files in `/root/apply-lab/` |
| `docs/overview.md` | What the environment contains and ideas to try |
