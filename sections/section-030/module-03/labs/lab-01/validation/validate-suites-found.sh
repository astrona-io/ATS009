#!/usr/bin/env bash
# Three kyverno-test.yaml files under tests/, naming the right policies and Pods,
# and using variables, userinfo and exceptions.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
cd "${LAB_DIR}" 2>/dev/null || { echo "FAIL: ${LAB_DIR} not found"; exit 1; }

count=$(find tests -name kyverno-test.yaml 2>/dev/null | wc -l | tr -d ' ')
if [[ "${count}" -lt 3 ]]; then
  echo "FAIL: found ${count} kyverno-test.yaml files under tests/, expected at least 3 (one for each scenario)"
  exit 1
fi

all=$(find tests -name kyverno-test.yaml -exec cat {} +)
for word in restrict-registry platform-admin-only good-registry-pod bad-registry-pod legacy-pod platform-pod; do
  echo "${all}" | grep -q "${word}" || { echo "FAIL: no claim mentions '${word}'"; exit 1; }
done
echo "${all}" | grep -q "^variables:" || { echo "FAIL: no manifest uses the variables field"; exit 1; }
echo "${all}" | grep -q "^userinfo:" || { echo "FAIL: no manifest uses the userinfo field"; exit 1; }
echo "${all}" | grep -q "^exceptions:" || { echo "FAIL: no manifest uses the exceptions field"; exit 1; }

echo "PASS: ${count} test manifests under tests/ use variables, userinfo and exceptions."
