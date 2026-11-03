#!/usr/bin/env bash
# kyverno-test.yaml must name both policies, all three resources, and use the
# patchedResources and generatedResource keys.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
cd "${LAB_DIR}" 2>/dev/null || { echo "FAIL: ${LAB_DIR} not found"; exit 1; }

[[ -f kyverno-test.yaml ]] || { echo "FAIL: kyverno-test.yaml not found in ${LAB_DIR}"; exit 1; }

results_part=$(sed -n '/^results:/,$p' kyverno-test.yaml)
[[ -n "${results_part}" ]] || { echo "FAIL: kyverno-test.yaml has no results list"; exit 1; }

for name in web-pod batch-pod team-a add-managed-by add-default-deny set-managed-by create-default-deny; do
  echo "${results_part}" | grep -q "${name}" || { echo "FAIL: no claim that mentions '${name}'"; exit 1; }
done
echo "${results_part}" | grep -q "patchedResources" || { echo "FAIL: the mutate claim has no patchedResources file"; exit 1; }
echo "${results_part}" | grep -q "generatedResource" || { echo "FAIL: the generate claim has no generatedResource file"; exit 1; }
echo "${results_part}" | grep -Eq "result:[[:space:]]*skip" || { echo "FAIL: no result: skip claim for batch-pod"; exit 1; }

echo "PASS: kyverno-test.yaml covers both policies, all three resources, a patched file, a generated file and a skip."
