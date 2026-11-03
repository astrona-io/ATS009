#!/usr/bin/env bash
# The saved cluster report is a ClusterPolicyReport: compliant-app passes, legacy-app fails.
set -u

report_file="/root/apply-lab/cluster-report.yaml"

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

if ! echo "$pairs" | grep -qx "compliant-app pass"; then
  echo "FAIL: the report does not show compliant-app with result: pass"
  exit 1
fi

if ! echo "$pairs" | grep -qx "legacy-app fail"; then
  echo "FAIL: the report does not show legacy-app with result: fail"
  exit 1
fi

echo "PASS: cluster report shows compliant-app as pass and legacy-app as fail."
exit 0
