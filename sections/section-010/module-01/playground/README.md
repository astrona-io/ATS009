# Installing & Verifying the Kyverno CLI - Playground

- **Slug:** ats-009-playground-010-01
- **Type:** Astrona playground - clean environment, no task, no grading

A `kind` cluster with the Kyverno controller `v1.13.2` running in the namespace `kyverno`. The `kyverno` command-line tool is **not** installed: you install it while you read the module. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-009-playground-010-01
```

`astrona destroy` takes the environment name (`metadata.name`), not the path. `astrona submit` and `astrona test` do not apply: there is no grading.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `bootstrap/01-install-kyverno.sh` | Installs the Kyverno controller `v1.13.2` and waits for its four Deployments |
| `docs/overview.md` | What the environment contains and ideas to try |
