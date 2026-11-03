#!/usr/bin/env bash
# Repairs bad-registry-pod in a scratch copy. A suite that really claims fail for it must then fail.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
[[ -d "${LAB_DIR}/tests" ]] || { echo "FAIL: ${LAB_DIR}/tests not found"; exit 1; }
[[ -f "${LAB_DIR}/resources/bad-registry-pod.yaml" ]] || { echo "FAIL: resources/bad-registry-pod.yaml not found; do not remove the provided files"; exit 1; }

scratch=$(mktemp -d)
trap 'rm -rf "${scratch}"' EXIT
cp -R "${LAB_DIR}/." "${scratch}/"

sed 's#docker.io/library/nginx:1.25#registry.example.com/team/app:1.0#' "${LAB_DIR}/resources/bad-registry-pod.yaml" > "${scratch}/resources/bad-registry-pod.yaml"
if cmp -s "${LAB_DIR}/resources/bad-registry-pod.yaml" "${scratch}/resources/bad-registry-pod.yaml"; then
  echo "FAIL: resources/bad-registry-pod.yaml was changed; restore the provided file"
  exit 1
fi

cd "${scratch}"
if kyverno test . >/dev/null 2>&1; then
  echo "FAIL: the suite still passes when bad-registry-pod is repaired, so its fail claim is not really asserted"
  exit 1
fi

echo "PASS: the suite notices when bad-registry-pod stops failing."
