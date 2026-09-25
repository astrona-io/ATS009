# Offline & Cluster Policy Apply Lab

Welcome to the Module 1 targeted practice sandbox. In this lab, you will run `kyverno apply` offline against local policy and resource files, apply the same policy to a live cluster, generate a `PolicyReport` with `--cluster --policy-report`, and confirm real admission-time enforcement.

## Launching the Lab
Run the following command in your terminal to boot the kind Kubernetes cluster:
```bash
astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-020/module-01/labs/lab-01
```
