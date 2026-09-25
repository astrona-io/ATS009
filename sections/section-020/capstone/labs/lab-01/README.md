# kyverno apply Capstone Lab

Welcome to the Section 020 Capstone Challenge. In this lab, you will mock a `ConfigMap`-backed policy `context` for an offline `kyverno apply` run using a values file, then apply the same policy live and prove it resolves the real `ConfigMap` on its own, finishing with a `--cluster --policy-report` audit.

## Launching the Lab
Run the following command in your terminal to boot the kind Kubernetes cluster:
```bash
astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-020/capstone/labs/lab-01
```
