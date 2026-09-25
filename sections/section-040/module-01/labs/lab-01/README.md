# kyverno jp Query Sandbox

Welcome to the Module 1 targeted practice sandbox. In this lab, you will use `kyverno jp query` — the standalone command-line interface to Kyverno's JMESPath engine — to extract and transform values from a sample Pod manifest, exactly the way a policy's `context`, `preconditions`, or `foreach` block would.

## Launching the Lab
Run the following command in your terminal to boot the kind Kubernetes cluster:
```bash
astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-040/module-01/labs/lab-01
```
