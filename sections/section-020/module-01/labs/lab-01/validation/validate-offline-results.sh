#!/usr/bin/env bash
# The offline apply result is saved as a table: compliant-app passes, legacy-app fails.
set -u

offline_file="/root/apply-lab/offline-results.txt"

if [[ ! -s "$offline_file" ]]; then
  echo "FAIL: $offline_file is missing or empty"
  exit 1
fi

if ! grep -i "compliant-app" "$offline_file" | grep -qi "pass"; then
  echo "FAIL: no line in $offline_file shows compliant-app with a pass result"
  exit 1
fi

if ! grep -i "legacy-app" "$offline_file" | grep -qi "fail"; then
  echo "FAIL: no line in $offline_file shows legacy-app with a fail result"
  exit 1
fi

echo "PASS: offline results list compliant-app as pass and legacy-app as fail."
exit 0
