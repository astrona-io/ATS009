#!/usr/bin/env bash
# kyverno-test.yaml must name both policies, all three rules and all four Pods.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
cd "${LAB_DIR}" 2>/dev/null || { echo "FAIL: ${LAB_DIR} not found"; exit 1; }

[[ -f kyverno-test.yaml ]] || { echo "FAIL: kyverno-test.yaml not found in ${LAB_DIR}"; exit 1; }

results_part=$(sed -n '/^results:/,$p' kyverno-test.yaml)
[[ -n "${results_part}" ]] || { echo "FAIL: kyverno-test.yaml has no results list"; exit 1; }

for name in good-pod bad-nonroot-pod bad-image-pod bad-both-pod; do
  echo "${results_part}" | grep -q "${name}" || { echo "FAIL: no claim about Pod '${name}'"; exit 1; }
done
for policy in require-run-as-nonroot disallow-latest-tag; do
  echo "${results_part}" | grep -q "${policy}" || { echo "FAIL: no claim about policy '${policy}'"; exit 1; }
done
for rule in check-runAsNonRoot require-image-tag validate-image-tag; do
  echo "${results_part}" | grep -q "${rule}" || { echo "FAIL: no claim about rule '${rule}'"; exit 1; }
done

echo "PASS: kyverno-test.yaml names both policies, all three rules and all four Pods."
