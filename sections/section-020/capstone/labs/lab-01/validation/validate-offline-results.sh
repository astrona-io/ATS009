#!/usr/bin/env bash
# The offline run used the values file: trusted-app passes, untrusted-app fails (no error).
set -u

offline_file="/root/apply-capstone/offline-results.txt"

if [[ ! -s "$offline_file" ]]; then
  echo "FAIL: $offline_file is missing or empty"
  exit 1
fi

# "/trusted-app" cannot match inside ".../untrusted-app".
if ! grep -i "/trusted-app" "$offline_file" | grep -qi "pass"; then
  echo "FAIL: no line in $offline_file shows trusted-app with a pass result"
  exit 1
fi

if ! grep -i "untrusted-app" "$offline_file" | grep -qi "fail"; then
  echo "FAIL: no line in $offline_file shows untrusted-app with a fail result (was the ConfigMap value supplied with -f?)"
  exit 1
fi

echo "PASS: offline results show trusted-app as pass and untrusted-app as fail."
exit 0
