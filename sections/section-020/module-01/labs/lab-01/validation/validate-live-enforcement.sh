#!/usr/bin/env bash
# The old Pod survives, the new unlabelled Pod is turned away.
set -u

if ! kubectl -n apps get pod legacy-app >/dev/null 2>&1; then
  echo "FAIL: legacy-app should still exist in apps (it was admitted before the policy)"
  exit 1
fi

if kubectl -n apps get pod new-app >/dev/null 2>&1; then
  echo "FAIL: new-app exists in apps; the policy should have blocked it"
  exit 1
fi

# A server-side dry run goes through the same admission check as a real create.
if kubectl -n apps run grader-probe --image=nginx:alpine --dry-run=server >/dev/null 2>&1; then
  echo "FAIL: an unlabelled Pod is still admitted in apps; the policy is not enforcing"
  exit 1
fi

echo "PASS: legacy-app still runs and a new unlabelled Pod is rejected."
exit 0
