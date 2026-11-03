#!/usr/bin/env bash
# The policy is live and Enforce.
set -u

action=$(kubectl get clusterpolicy check-registry-cm -o jsonpath='{.spec.validationFailureAction}' 2>/dev/null || true)

if [[ -z "$action" ]]; then
  echo "FAIL: ClusterPolicy 'check-registry-cm' not found in the cluster"
  exit 1
fi

if [[ "$(echo "$action" | tr '[:upper:]' '[:lower:]')" != "enforce" ]]; then
  echo "FAIL: validationFailureAction is '$action', expected Enforce"
  exit 1
fi

echo "PASS: check-registry-cm is live and set to Enforce."
exit 0
