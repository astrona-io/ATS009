#!/usr/bin/env bash
# The task asks to group Pods that share a verdict: five results entries are
# enough for three rules and two verdicts at most.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
cd "${LAB_DIR}" 2>/dev/null || { echo "FAIL: ${LAB_DIR} not found"; exit 1; }

[[ -f kyverno-test.yaml ]] || { echo "FAIL: kyverno-test.yaml not found"; exit 1; }

entries=$(sed -n '/^results:/,$p' kyverno-test.yaml | grep -c -E '^[[:space:]]*-[[:space:]]+policy:' || true)
if [[ "${entries}" -lt 1 ]]; then
  echo "FAIL: no results entries found"
  exit 1
fi
if [[ "${entries}" -gt 5 ]]; then
  echo "FAIL: ${entries} results entries. Group the Pods that share a verdict for the same rule; five entries are enough."
  exit 1
fi

echo "PASS: ${entries} results entries, with Pods grouped by shared verdict."
