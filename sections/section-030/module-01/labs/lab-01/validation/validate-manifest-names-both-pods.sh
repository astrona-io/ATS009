#!/usr/bin/env bash
# The manifest must still name both Pods, and must still hold real results.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
cd "${LAB_DIR}" 2>/dev/null || { echo "FAIL: ${LAB_DIR} not found"; exit 1; }

[[ -f kyverno-test.yaml ]] || { echo "FAIL: kyverno-test.yaml not found in ${LAB_DIR}"; exit 1; }

grep -q "good-pod" kyverno-test.yaml || { echo "FAIL: no claim about good-pod"; exit 1; }
grep -q "bad-pod" kyverno-test.yaml || { echo "FAIL: no claim about bad-pod (did you delete the failing case?)"; exit 1; }

# Both Pods must appear in a results entry, not only in the resources list.
results_part=$(sed -n '/^results:/,$p' kyverno-test.yaml)
echo "${results_part}" | grep -q "good-pod" || { echo "FAIL: good-pod is not in the results list"; exit 1; }
echo "${results_part}" | grep -q "bad-pod" || { echo "FAIL: bad-pod is not in the results list"; exit 1; }

echo "PASS: kyverno-test.yaml makes a claim about both good-pod and bad-pod."
