#!/usr/bin/env bash
# Points the exception at another Pod in a scratch copy. A suite that really tests the exception must then fail.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
[[ -d "${LAB_DIR}/tests" ]] || { echo "FAIL: ${LAB_DIR}/tests not found"; exit 1; }
[[ -f "${LAB_DIR}/policies/legacy-exception.yaml" ]] || { echo "FAIL: policies/legacy-exception.yaml not found; do not remove the provided files"; exit 1; }

scratch=$(mktemp -d)
trap 'rm -rf "${scratch}"' EXIT
cp -R "${LAB_DIR}/." "${scratch}/"

sed 's/legacy-pod/other-pod/' "${LAB_DIR}/policies/legacy-exception.yaml" > "${scratch}/policies/legacy-exception.yaml"
if cmp -s "${LAB_DIR}/policies/legacy-exception.yaml" "${scratch}/policies/legacy-exception.yaml"; then
  echo "FAIL: policies/legacy-exception.yaml was changed; restore the provided file"
  exit 1
fi

cd "${scratch}"
if kyverno test . >/dev/null 2>&1; then
  echo "FAIL: the suite still passes when the exception no longer covers legacy-pod, so the skip claim is not really tested"
  exit 1
fi

echo "PASS: the suite notices when the exception stops covering legacy-pod."
