#!/usr/bin/env bash
# gate-table.txt is a --table run with --audit-warn: legacy-app is a warning, compliant-app passes.
set -u

file="/root/apply-gate/gate-table.txt"

if [[ ! -s "$file" ]]; then
  echo "FAIL: $file is missing or empty"
  exit 1
fi

legacy="$(grep 'legacy-app' "$file" || true)"
compliant="$(grep 'compliant-app' "$file" || true)"

if [[ -z "$legacy" || -z "$compliant" ]]; then
  echo "FAIL: $file must list both legacy-app and compliant-app (use --table and run on both Pod files)"
  exit 1
fi

if ! printf '%s\n' "$legacy" | grep -qi 'warn'; then
  echo "FAIL: legacy-app is not a Warn row (did you add --audit-warn?)"
  exit 1
fi

if ! printf '%s\n' "$compliant" | grep -qi 'pass'; then
  echo "FAIL: compliant-app is not a Pass row"
  exit 1
fi

echo "PASS: gate-table.txt shows legacy-app as Warn and compliant-app as Pass."
exit 0
