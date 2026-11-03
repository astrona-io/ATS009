#!/usr/bin/env bash
# The mutated Pod was applied to the cluster.
set -u

tier=$(kubectl -n apps get pod scout -o jsonpath='{.metadata.labels.tier}' 2>/dev/null || true)

if [[ -z "$tier" ]]; then
  echo "FAIL: Pod scout in apps is missing, or it has no tier label (apply scout-mutated.yaml with kubectl)"
  exit 1
fi

if [[ "$tier" != "standard" ]]; then
  echo "FAIL: Pod scout has tier=$tier, expected standard"
  exit 1
fi

echo "PASS: Pod scout runs in apps with tier=standard."
exit 0
