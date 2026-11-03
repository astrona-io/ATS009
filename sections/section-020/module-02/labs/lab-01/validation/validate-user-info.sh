#!/usr/bin/env bash
# bridge-access passes for scout when the user info file gives the bridge-officer role,
# and still fails for an ordinary user.
set -u

dir="/root/mutate-lab"
info="$dir/bridge-officer.yaml"

if [[ ! -s "$info" ]]; then
  echo "FAIL: $info is missing or empty"
  exit 1
fi

if ! kyverno apply "$dir/bridge-policy.yaml" --resource "$dir/scout.yaml" -u "$info" >/dev/null 2>&1; then
  echo "FAIL: kyverno apply with -u $info does not exit 0 (is the role bridge-officer under clusterRoles?)"
  exit 1
fi

if kyverno apply "$dir/bridge-policy.yaml" --resource "$dir/scout.yaml" >/dev/null 2>&1; then
  echo "FAIL: the policy no longer fails without user info; do not edit bridge-policy.yaml"
  exit 1
fi

echo "PASS: the user info file clears bridge-access and the policy still fails without it."
exit 0
