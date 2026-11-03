#!/usr/bin/env bash
# Plain `kyverno test`: exit code 0 and at least three tests passed.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
cd "${LAB_DIR}" 2>/dev/null || { echo "FAIL: ${LAB_DIR} not found"; exit 1; }

[[ -f kyverno-test.yaml ]] || { echo "FAIL: kyverno-test.yaml not found"; exit 1; }

status=0
output=$(kyverno test . 2>&1) || status=$?
echo "${output}"

if [[ ${status} -ne 0 ]]; then
  echo "FAIL: kyverno test exited with ${status}: at least one claim does not match the real result"
  exit 1
fi

count=$(echo "${output}" | sed -n 's/.*Test Summary: \([0-9][0-9]*\) tests\{0,1\} passed.*/\1/p' | head -1)
if [[ -z "${count}" || "${count}" -lt 3 ]]; then
  echo "FAIL: expected at least 3 tests (mutate pass, mutate skip, generate pass), found '${count:-none}'"
  exit 1
fi

echo "PASS: kyverno test exits 0 and ${count} tests passed."
