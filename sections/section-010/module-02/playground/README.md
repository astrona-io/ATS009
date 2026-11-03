# The Kyverno CLI Toolbox - Playground

- **Slug:** ats-009-playground-010-02
- **Type:** Astrona playground - clean environment, no task, no grading

A `kind` cluster with the Kyverno controller `v1.13.2` running, the `kyverno` CLI `v1.13.2` installed in `/usr/local/bin`, and a scratch folder `/root/toolbox` with one policy and two Pod files. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-009-playground-010-02
```

`astrona destroy` takes the environment name (`metadata.name`), not the path. `astrona submit` and `astrona test` do not apply: there is no grading.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `bootstrap/01-install-kyverno.sh` | Installs the Kyverno controller `v1.13.2` |
| `bootstrap/02-install-kyverno-cli.sh` | Installs the `kyverno` CLI `v1.13.2` |
| `bootstrap/03-setup-scratch-dir.sh` | Writes `policy.yaml`, `compliant-app.yaml` and `legacy-app.yaml` into `/root/toolbox` |
| `docs/overview.md` | What the environment contains and ideas to try |
