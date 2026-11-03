#!/usr/bin/env bash
# Takes the cluster-admin role away from the admin badge in a scratch copy. The admin suite must then fail.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
[[ -d "${LAB_DIR}/tests" ]] || { echo "FAIL: ${LAB_DIR}/tests not found"; exit 1; }
[[ -f "${LAB_DIR}/userinfo/admin.yaml" ]] || { echo "FAIL: userinfo/admin.yaml not found; do not remove the provided files"; exit 1; }

scratch=$(mktemp -d)
trap 'rm -rf "${scratch}"' EXIT
cp -R "${LAB_DIR}/." "${scratch}/"

sed 's/cluster-admin/edit/' "${LAB_DIR}/userinfo/admin.yaml" > "${scratch}/userinfo/admin.yaml"
if cmp -s "${LAB_DIR}/userinfo/admin.yaml" "${scratch}/userinfo/admin.yaml"; then
  echo "FAIL: userinfo/admin.yaml was changed; restore the provided file"
  exit 1
fi

cd "${scratch}"
if kyverno test . >/dev/null 2>&1; then
  echo "FAIL: the suite still passes when the admin badge loses cluster-admin, so the admin userinfo file is not really used"
  exit 1
fi

echo "PASS: the suite notices when the admin badge changes."
