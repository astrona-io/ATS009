# Advanced JMESPath: Functions, Projections And Real Policy Data - Playground

- **Slug:** ats-009-playground-040-02
- **Type:** Astrona playground - a clean environment, no task, no grading

A training solar system (a `kind` cluster) with the Kyverno controller `v1.13.2`, the `kyverno` command-line tool `1.13.2` in `/usr/local/bin`, and three files in `~/jp-playground/`: `pods.json` (a list of three Pods), `request.json` (a Pod inside an admission request) and `settings.json` (a JSON string, an encoded token, a messy path and a start time). Nothing to submit.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-040/module-02/playground
astrona destroy ats-009-playground-040-02
```

Authors can run a local copy with `astrona run -c sections/section-040/module-02/playground`. `astrona destroy` takes the environment name (`metadata.name`), not the path. `astrona submit` and `astrona test` do not apply: there is no grading.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `bootstrap/01-install-kyverno.sh` | Installs the Kyverno controller `v1.13.2` |
| `bootstrap/02-install-kyverno-cli.sh` | Installs the CLI `1.13.2` |
| `bootstrap/03-seed-playground.sh` | Writes `pods.json`, `request.json` and `settings.json` |
| `docs/overview.md` | What the environment contains and ideas to try |
