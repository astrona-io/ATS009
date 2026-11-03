#!/usr/bin/env bash
# Changes the label value that the mutate rule paints, in a scratch copy. A suite
# that really compares the patched Pod must then fail.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
[[ -f "${LAB_DIR}/kyverno-test.yaml" ]] || { echo "FAIL: kyverno-test.yaml not found"; exit 1; }
[[ -f "${LAB_DIR}/add-managed-by.yaml" ]] || { echo "FAIL: add-managed-by.yaml not found"; exit 1; }

scratch=$(mktemp -d)
trap 'rm -rf "${scratch}"' EXIT
cp -R "${LAB_DIR}/." "${scratch}/"

sed 's/managed-by: kyverno/managed-by: platform/' "${LAB_DIR}/add-managed-by.yaml" > "${scratch}/add-managed-by.yaml"
if cmp -s "${LAB_DIR}/add-managed-by.yaml" "${scratch}/add-managed-by.yaml"; then
  echo "FAIL: add-managed-by.yaml no longer paints managed-by: kyverno; do not edit the policy"
  exit 1
fi

cd "${scratch}"
if kyverno test . >/dev/null 2>&1; then
  echo "FAIL: the suite still passes when the rule paints a different label, so the patched Pod is not really compared"
  exit 1
fi

echo "PASS: the suite notices when the mutate output changes."
