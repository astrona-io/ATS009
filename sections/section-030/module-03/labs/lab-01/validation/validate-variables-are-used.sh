#!/usr/bin/env bash
# Changes the approved registry in a scratch copy of the values file. Suites that really use the values file must then fail.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
[[ -d "${LAB_DIR}/tests" ]] || { echo "FAIL: ${LAB_DIR}/tests not found"; exit 1; }
[[ -f "${LAB_DIR}/values/registry-values.yaml" ]] || { echo "FAIL: values/registry-values.yaml not found; do not remove the provided files"; exit 1; }

scratch=$(mktemp -d)
trap 'rm -rf "${scratch}"' EXIT
cp -R "${LAB_DIR}/." "${scratch}/"

sed 's/registry.example.com/other.example.com/' "${LAB_DIR}/values/registry-values.yaml" > "${scratch}/values/registry-values.yaml"
if cmp -s "${LAB_DIR}/values/registry-values.yaml" "${scratch}/values/registry-values.yaml"; then
  echo "FAIL: values/registry-values.yaml was changed; restore the provided file"
  exit 1
fi

cd "${scratch}"
if kyverno test . >/dev/null 2>&1; then
  echo "FAIL: the suite still passes with another approved registry, so the values file is not really used"
  exit 1
fi

echo "PASS: the suite notices when the approved registry changes."
