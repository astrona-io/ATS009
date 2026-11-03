#!/usr/bin/env bash
# gate-exit-code.txt holds the exit code of the Audit policy run with --audit-warn --warn-exit-code 3.
set -u

dir="/root/apply-gate"
file="$dir/gate-exit-code.txt"

if [[ ! -s "$file" ]]; then
  echo "FAIL: $file is missing or empty"
  exit 1
fi

value="$(tr -d '[:space:]' < "$file")"
if [[ "$value" != "3" ]]; then
  echo "FAIL: $file holds '$value', expected 3 (the --warn-exit-code you set)"
  exit 1
fi

kyverno apply "$dir/audit-policy.yaml" --resource "$dir/legacy-app.yaml" --resource "$dir/compliant-app.yaml" --audit-warn --warn-exit-code 3 >/dev/null 2>&1
actual=$?
if [[ "$actual" -ne 3 ]]; then
  echo "FAIL: the Audit policy with --audit-warn --warn-exit-code 3 exits $actual, expected 3"
  exit 1
fi

echo "PASS: gate-exit-code.txt holds 3, the exit code of a run with warnings."
exit 0
