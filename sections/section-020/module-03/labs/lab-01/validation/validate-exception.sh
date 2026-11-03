#!/usr/bin/env bash
# A PolicyException for legacy-app makes the Enforce policy pass, and the policy still fails without it.
set -u

dir="/root/apply-gate"
exc="$dir/legacy-exception.yaml"

if [[ ! -s "$exc" ]]; then
  echo "FAIL: $exc is missing or empty"
  exit 1
fi

if ! grep -Eq '^kind:[[:space:]]*PolicyException[[:space:]]*$' "$exc"; then
  echo "FAIL: $exc is not a PolicyException (kind: PolicyException)"
  exit 1
fi

if ! kyverno apply "$dir/enforce-policy.yaml" --resource "$dir/legacy-app.yaml" --resource "$dir/compliant-app.yaml" -e "$exc" >/dev/null 2>&1; then
  echo "FAIL: kyverno apply with -e $exc does not exit 0 (check policyName, ruleNames and the Pod name in match)"
  exit 1
fi

if kyverno apply "$dir/enforce-policy.yaml" --resource "$dir/legacy-app.yaml" --resource "$dir/compliant-app.yaml" >/dev/null 2>&1; then
  echo "FAIL: the policy no longer fails without the exception; do not edit enforce-policy.yaml"
  exit 1
fi

echo "PASS: the exception clears legacy-app and the policy still fails without it."
exit 0
