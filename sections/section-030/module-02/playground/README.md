# Testing Mutate and Generate Rules: Playground

- **Slug:** ats-009-playground-030-02
- **Type:** Astrona playground: a clean environment, no task, no grading

A terminal with the `kyverno` CLI `1.13.2` and a practice folder `~/kyverno-cli-lab`. The folder holds a mutate policy, a generate policy, a clone policy and the resources they act on. It has no test manifest and no expected-output files. You write those yourself. Nothing to submit.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-030/module-02/playground
astrona destroy ats-009-playground-030-02
```

`astrona destroy` takes the environment name (`metadata.name`), not the path. `astrona submit` and `astrona test` do not apply: there is no grading.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `bootstrap/01-install-kyverno-cli.sh` | Installs the CLI 1.13.2 into `/usr/local/bin` |
| `bootstrap/02-seed-files.sh` | Writes the policies and resources to `~/kyverno-cli-lab` |
| `docs/overview.md` | What is in the playground and ideas to try |
