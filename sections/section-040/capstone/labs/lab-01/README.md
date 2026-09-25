# kyverno jp Capstone Challenge

Welcome to the Section 040 Capstone. In this lab, you will combine stock JMESPath syntax with several of Kyverno's custom functions — `semver_compare`, `label_match`, and `regex_match` — against a single payload shaped like a real policy's `preconditions`/`context` block, using `kyverno jp function` to confirm each function's behavior before you rely on it.

## Launching the Lab
Run the following command in your terminal to boot the kind Kubernetes cluster:
```bash
astrona run --git git@github.com:astrona-io/ATS009.git -c sections/section-040/capstone/labs/lab-01
```
