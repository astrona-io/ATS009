#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -u

cd /root/apply-gate

cat <<'YAML' > legacy-exception.yaml
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
YAML

kyverno apply audit-policy.yaml -r legacy-app.yaml -r compliant-app.yaml --audit-warn --warn-exit-code 3 >/dev/null 2>&1
echo $? > gate-exit-code.txt

kyverno apply audit-policy.yaml -r legacy-app.yaml -r compliant-app.yaml --audit-warn --table > gate-table.txt 2>&1
echo "[solution] Done."
exit 0
