# Mutate And Generate With apply - Playground

- **Slug:** ats-009-playground-020-02
- **Type:** Astrona playground - clean environment, no task, no grading

A `kind` cluster with the `kyverno` CLI `1.13.2` in `/usr/local/bin`. There is
no Kyverno controller: only the CLI runs the rules. The namespace `apps`
exists and has no Pods. Example resource files are in `/root/apply-mutate/`.
Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-009-playground-020-02
```

`astrona destroy` takes the environment name (`metadata.name`), not the path.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `bootstrap/01-install-kyverno-cli.sh` | Installs the CLI v1.13.2 |
| `bootstrap/02-setup-mutate-playground.sh` | Creates `apps` and the files in `/root/apply-mutate/` |
| `docs/overview.md` | What the environment contains and ideas to try |
