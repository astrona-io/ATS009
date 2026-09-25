#!/usr/bin/env bash
# Confirms kyverno-test.yaml exists, covers every resource and both
# policies, and its declared results truthfully match Kyverno's real
# evaluation.

set -u

LAB_DIR="${HOME}/kyverno-cli-lab"
cd "${LAB_DIR}" 2>/dev/null || {
  echo "FAIL: capstone - lab directory ${LAB_DIR} not found"
  exit 1
}

if [[ ! -f kyverno-test.yaml ]]; then
  echo "FAIL: capstone - kyverno-test.yaml not found in ${LAB_DIR}"
  exit 1
fi

for name in good-pod bad-nonroot-pod bad-image-pod bad-both-pod; do
  grep -q "$name" kyverno-test.yaml || {
    echo "FAIL: capstone - no assertion found covering resource '$name'"
    exit 1
  }
done

for policy in require-run-as-nonroot disallow-latest-tag; do
  grep -q "$policy" kyverno-test.yaml || {
    echo "FAIL: capstone - no assertion found covering policy '$policy'"
    exit 1
  }
done

output=$(kyverno test . --require-tests 2>&1)
status=$?

echo "$output"

if [[ $status -ne 0 ]]; then
  echo "FAIL: capstone - kyverno-test.yaml's declared results do not match Kyverno's actual evaluation (exit code $status)"
  exit 1
fi

echo "PASS: kyverno-test.yaml covers both policies and all four resources, and every declared result matches Kyverno's real evaluation."
exit 0
