#!/usr/bin/env bash
# Runs the learner's suite with plain `kyverno test` and checks the exit code.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
cd "${LAB_DIR}" 2>/dev/null || { echo "FAIL: ${LAB_DIR} not found"; exit 1; }

[[ -f kyverno-test.yaml ]] || { echo "FAIL: kyverno-test.yaml not found"; exit 1; }

status=0
output=$(kyverno test . 2>&1) || status=$?
echo "${output}"

if [[ ${status} -ne 0 ]]; then
  echo "FAIL: kyverno test exited with ${status}: at least one claim does not match Kyverno's real result"
  exit 1
fi

# An emptied suite also exits 0 on this CLI version, so at least two tests must have run.
count=$(echo "${output}" | sed -n 's/.*Test Summary: \([0-9][0-9]*\) tests\{0,1\} passed.*/\1/p' | head -1)
if [[ -z "${count}" || "${count}" -lt 2 ]]; then
  echo "FAIL: fewer than two tests ran (found '${count:-none}')"
  exit 1
fi

echo "PASS: kyverno test exits 0 and ${count} tests passed."
