#!/usr/bin/env bash
# user-info.yaml names alice@example.com, the group developers and the cluster role admin.

set -u

USER_INFO="/root/toolbox-lab/user-info.yaml"

if [[ ! -s "$USER_INFO" ]]; then
  echo "FAIL: $USER_INFO does not exist or is empty"
  exit 1
fi

for needle in alice@example.com developers admin; do
  if ! grep -q "$needle" "$USER_INFO"; then
    echo "FAIL: $USER_INFO does not mention $needle"
    exit 1
  fi
done

echo "PASS: user-info.yaml names alice@example.com, developers and admin."
exit 0
