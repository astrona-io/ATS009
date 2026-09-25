#!/usr/bin/env bash
# Confirms the offline mocked-context results, live enforcement in both directions,
# and the cluster policy report.

set -u

offline_file="/root/apply-capstone/offline-results.txt"
report_file="/root/apply-capstone/cluster-report.yaml"

if [[ ! -s "$offline_file" ]]; then
  echo "FAIL: offline apply - $offline_file is missing or empty"
  exit 1
fi

if ! grep -q "trusted-app" "$offline_file" || ! grep -q "untrusted-app" "$offline_file"; then
  echo "FAIL: offline apply - $offline_file does not reference both trusted-app and untrusted-app"
  exit 1
fi

if ! grep -q "pass: 1, fail: 1" "$offline_file"; then
  echo "FAIL: offline apply - $offline_file does not show a 1 pass / 1 fail summary (was the context value mocked correctly?)"
  exit 1
fi

policy_json=$(kubectl get clusterpolicy check-registry-cm -o json 2>/dev/null)
if [[ -z "$policy_json" ]]; then
  echo "FAIL: live policy - ClusterPolicy 'check-registry-cm' not found"
  exit 1
fi

action=$(echo "$policy_json" | grep -o '"validationFailureAction"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"([^"]+)"$/\1/')
if [[ "$action" != "Enforce" ]]; then
  echo "FAIL: live policy - validationFailureAction is '$action', expected Enforce"
  exit 1
fi

trusted_image=$(kubectl -n apps get pod trusted-app -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
if [[ -z "$trusted_image" ]]; then
  echo "FAIL: live enforcement - trusted-app not found in apps; it should have been admitted"
  exit 1
fi

if [[ "$trusted_image" != registry.internal/* ]]; then
  echo "FAIL: live enforcement - trusted-app has image '$trusted_image', expected a registry.internal/ image"
  exit 1
fi

if kubectl -n apps get pod untrusted-app >/dev/null 2>&1; then
  echo "FAIL: live enforcement - untrusted-app exists in apps; it should have been blocked by check-registry-cm"
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

if ! grep -q "trusted-app" "$report_file" || ! grep -q "result: pass" "$report_file"; then
  echo "FAIL: cluster report - $report_file does not show trusted-app with result: pass"
  exit 1
fi

echo "PASS: offline apply mocked the ConfigMap context correctly, live enforcement worked both ways, and the cluster policy report was generated."
exit 0
