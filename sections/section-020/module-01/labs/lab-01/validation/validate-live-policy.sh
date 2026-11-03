#!/usr/bin/env bash
# The policy is live in the cluster and set to Enforce.
set -u

action=$(kubectl get clusterpolicy require-team-label -o jsonpath='{.spec.validationFailureAction}' 2>/dev/null || true)

if [[ -z "$action" ]]; then
  echo "FAIL: ClusterPolicy 'require-team-label' not found in the cluster"
  exit 1
fi

if [[ "$(echo "$action" | tr '[:upper:]' '[:lower:]')" != "enforce" ]]; then
  echo "FAIL: validationFailureAction is '$action', expected Enforce"
  exit 1
fi

echo "PASS: require-team-label is live and set to Enforce."
exit 0
