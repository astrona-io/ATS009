#!/usr/bin/env bash
# Confirms kyverno-test.yaml in ~/kyverno-cli-lab correctly and completely
# asserts Kyverno's real evaluation of good-pod (pass) and bad-pod (fail).

set -u

LAB_DIR="${HOME}/kyverno-cli-lab"
cd "${LAB_DIR}" 2>/dev/null || {
  echo "FAIL: kyverno-test.yaml - lab directory ${LAB_DIR} not found"
  exit 1
}

if [[ ! -f kyverno-test.yaml ]]; then
  echo "FAIL: kyverno-test.yaml - file not found in ${LAB_DIR}"
  exit 1
fi

grep -q "good-pod" kyverno-test.yaml || {
  echo "FAIL: kyverno-test.yaml - no assertion found for good-pod"
  exit 1
}
grep -q "bad-pod" kyverno-test.yaml || {
  echo "FAIL: kyverno-test.yaml - no assertion found for bad-pod (did you delete the failing case instead of fixing it?)"
  exit 1
}

output=$(kyverno test . --require-tests 2>&1)
status=$?

echo "$output"

if [[ $status -ne 0 ]]; then
  echo "FAIL: kyverno test - kyverno-test.yaml's declared results do not match Kyverno's actual evaluation (exit code $status)"
  exit 1
fi

echo "PASS: kyverno-test.yaml declares results that truthfully match Kyverno's real evaluation of both good-pod and bad-pod."
exit 0
