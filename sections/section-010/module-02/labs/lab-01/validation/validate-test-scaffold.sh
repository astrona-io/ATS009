#!/usr/bin/env bash
# scaffold-test.yaml lists the policy, both Pod files, and the expected results.

set -u

SCAFFOLD="/root/toolbox-lab/scaffold-test.yaml"

if [[ ! -s "$SCAFFOLD" ]]; then
  echo "FAIL: $SCAFFOLD does not exist or is empty"
  exit 1
fi

for needle in policy.yaml compliant-app.yaml legacy-app.yaml require-team-label check-team-label; do
  if ! grep -q "$needle" "$SCAFFOLD"; then
    echo "FAIL: $SCAFFOLD does not mention $needle"
    exit 1
  fi
done

# Print "<resource> <result>" for every entry of the results list.
verdicts="$(awk '
  /^[[:space:]]*-[[:space:]]*policy:/ { resource = "" }
  /^[[:space:]]+resource:/ { resource = $2 }
  /^[[:space:]]+result:/ { print resource, $2 }
' "$SCAFFOLD" | tr '[:upper:]' '[:lower:]')"

if ! echo "$verdicts" | grep -Eq '^compliant-app pass$'; then
  echo "FAIL: the results list does not expect 'pass' for compliant-app"
  exit 1
fi

if ! echo "$verdicts" | grep -Eq '^legacy-app fail$'; then
  echo "FAIL: the results list does not expect 'fail' for legacy-app"
  exit 1
fi

echo "PASS: scaffold-test.yaml lists the policy, both Pods, pass for compliant-app and fail for legacy-app."
exit 0
