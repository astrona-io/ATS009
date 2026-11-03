# Solution Walkthrough

Three steps: excuse the old ship, turn a warning into your own exit code, and keep a table of the results.

---

## Step 1: Write the exception

See the failure first:

```sh
cd /root/apply-gate
kyverno apply enforce-policy.yaml --resource legacy-app.yaml --resource compliant-app.yaml
echo $?
```

The summary reports one fail and `echo` prints `1`. Save this as `legacy-exception.yaml`:

```yaml
apiVersion: kyverno.io/v2beta1
kind: PolicyException
metadata:
  name: legacy-app-exception
  namespace: apps
spec:
  exceptions:
    - policyName: require-team-label
      ruleNames:
        - check-team-label
  match:
    any:
    - resources:
        kinds:
          - Pod
        names:
          - legacy-app
```

Run again with `-e`:

```sh
kyverno apply enforce-policy.yaml --resource legacy-app.yaml --resource compliant-app.yaml -e legacy-exception.yaml
echo $?
```

The exit code is `0`. The exception names the policy, the rule and the one Pod it excuses. Newer CLI versions print a deprecation warning about the `v2beta1` API on the error stream. That is fine, the result is the same.

Submit your work:

```sh
astrona submit -c sections/section-020/module-03/labs/lab-01
```

---

## Step 2: Set your own warning exit code

```sh
kyverno apply audit-policy.yaml --resource legacy-app.yaml --resource compliant-app.yaml --audit-warn --warn-exit-code 3
echo $?
```

`--audit-warn` turns the failure of an `Audit` policy into a warning. `--warn-exit-code 3` makes a run with warnings exit with `3`. Save the code right after the command, before anything else runs:

```sh
kyverno apply audit-policy.yaml --resource legacy-app.yaml --resource compliant-app.yaml --audit-warn --warn-exit-code 3
echo $? > gate-exit-code.txt
```

The file holds `3`.

---

## Step 3: Save the table

```sh
kyverno apply audit-policy.yaml --resource legacy-app.yaml --resource compliant-app.yaml --audit-warn --table > gate-table.txt
cat gate-table.txt
```

The table has one row per resource: `legacy-app` is a `Warn` and `compliant-app` is a `Pass`.

Submit again:

```sh
astrona submit -c sections/section-020/module-03/labs/lab-01
```
