#!/usr/bin/env bash
# Confirms the offline apply results, the live policy, the cluster policy report,
# and real admission-time enforcement on a new Pod.

set -u

offline_file="/root/apply-lab/offline-results.txt"
report_file="/root/apply-lab/cluster-report.yaml"

if [[ ! -s "$offline_file" ]]; then
  echo "FAIL: offline apply - $offline_file is missing or empty"
  exit 1
fi

if ! grep -q "legacy-app" "$offline_file" || ! grep -q "compliant-app" "$offline_file"; then
  echo "FAIL: offline apply - $offline_file does not reference both compliant-app and legacy-app"
  exit 1
fi

if ! grep -q "pass: 1, fail: 1" "$offline_file"; then
  echo "FAIL: offline apply - $offline_file does not show a 1 pass / 1 fail summary"
  exit 1
fi

policy_json=$(kubectl get clusterpolicy require-team-label -o json 2>/dev/null)
if [[ -z "$policy_json" ]]; then
  echo "FAIL: live policy - ClusterPolicy 'require-team-label' not found"
  exit 1
fi

action=$(echo "$policy_json" | grep -o '"validationFailureAction"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"([^"]+)"$/\1/')
if [[ "$action" != "Enforce" ]]; then
  echo "FAIL: live policy - validationFailureAction is '$action', expected Enforce"
  exit 1
fi

if [[ ! -s "$report_file" ]]; then
  echo "FAIL: cluster report - $report_file is missing or empty"
  exit 1
fi

if ! grep -q "ClusterPolicyReport" "$report_file"; then
  echo "FAIL: cluster report - $report_file does not look like a ClusterPolicyReport"
  exit 1
fi

if ! grep -q "compliant-app" "$report_file" || ! grep -q "legacy-app" "$report_file"; then
  echo "FAIL: cluster report - $report_file does not reference both compliant-app and legacy-app"
  exit 1
fi

if ! grep -q "result: pass" "$report_file" || ! grep -q "result: fail" "$report_file"; then
  echo "FAIL: cluster report - $report_file does not contain both a pass and a fail result"
  exit 1
fi

if ! kubectl -n apps get pod legacy-app >/dev/null 2>&1; then
  echo "FAIL: pre-existing state - legacy-app should still exist in apps (it predates the policy)"
  exit 1
fi

if kubectl -n apps get pod new-app >/dev/null 2>&1; then
  echo "FAIL: live enforcement - new-app exists in apps; it should have been blocked by require-team-label"
  exit 1
fi

echo "PASS: offline apply results captured, ClusterPolicyReport generated, and new-app correctly blocked by require-team-label."
exit 0
