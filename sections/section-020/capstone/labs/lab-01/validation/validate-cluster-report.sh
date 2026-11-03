#!/usr/bin/env bash
# The cluster report is a ClusterPolicyReport that shows trusted-app with result pass.
set -u

report_file="/root/apply-capstone/cluster-report.yaml"

if [[ ! -s "$report_file" ]]; then
  echo "FAIL: $report_file is missing or empty"
  exit 1
fi

if ! grep -q "ClusterPolicyReport" "$report_file"; then
  echo "FAIL: $report_file is not a ClusterPolicyReport (did you add --policy-report?)"
  exit 1
fi

# Pair each resource name with the result line that follows it.
pairs=$(awk '/^[[:space:]]*-?[[:space:]]*name:/ {n=$NF} /^[[:space:]]*result:/ {print n, tolower($NF)}' "$report_file")

if ! echo "$pairs" | grep -qx "trusted-app pass"; then
  echo "FAIL: the report does not show trusted-app with result: pass (run it with --cluster and no -f)"
  exit 1
fi

echo "PASS: the cluster report shows trusted-app as pass."
exit 0
