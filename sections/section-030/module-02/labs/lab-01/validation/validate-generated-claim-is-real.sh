#!/usr/bin/env bash
# Changes the NetworkPolicy type that the generate rule builds, in a scratch
# copy. A suite that really compares the generated resource must then fail.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
[[ -f "${LAB_DIR}/kyverno-test.yaml" ]] || { echo "FAIL: kyverno-test.yaml not found"; exit 1; }
[[ -f "${LAB_DIR}/add-default-deny.yaml" ]] || { echo "FAIL: add-default-deny.yaml not found"; exit 1; }

scratch=$(mktemp -d)
trap 'rm -rf "${scratch}"' EXIT
cp -R "${LAB_DIR}/." "${scratch}/"

sed 's/- Ingress/- Egress/' "${LAB_DIR}/add-default-deny.yaml" > "${scratch}/add-default-deny.yaml"
if cmp -s "${LAB_DIR}/add-default-deny.yaml" "${scratch}/add-default-deny.yaml"; then
  echo "FAIL: add-default-deny.yaml no longer lists Ingress; do not edit the policy"
  exit 1
fi

cd "${scratch}"
if kyverno test . >/dev/null 2>&1; then
  echo "FAIL: the suite still passes when the rule builds a different NetworkPolicy, so the generated resource is not really compared"
  exit 1
fi

echo "PASS: the suite notices when the generated resource changes."
