# JMESPath with the Kyverno CLI - Playground

- **Slug:** ats-009-playground-040-01
- **Type:** Astrona playground - a clean environment, no task, no grading

A training solar system (a `kind` cluster) with the Kyverno controller `v1.13.2`, the `kyverno` command-line tool `1.13.2` in `/usr/local/bin`, and one Pod file in `~/jp-playground/pod.json`. Nothing to submit. The cluster is not needed by `kyverno jp`; it is there so that the playground looks like the graded missions.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-040/module-01/playground
astrona destroy ats-009-playground-040-01
```

Authors can run a local copy with `astrona run -c sections/section-040/module-01/playground`. `astrona destroy` takes the environment name (`metadata.name`), not the path. `astrona submit` and `astrona test` do not apply: there is no grading.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `bootstrap/01-install-kyverno.sh` | Installs the Kyverno controller `v1.13.2` |
| `bootstrap/02-install-kyverno-cli.sh` | Installs the CLI `1.13.2` |
| `bootstrap/03-seed-playground.sh` | Writes `~/jp-playground/pod.json` |
| `docs/overview.md` | What the environment contains and ideas to try |
