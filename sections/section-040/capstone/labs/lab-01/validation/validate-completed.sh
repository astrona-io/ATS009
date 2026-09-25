#!/usr/bin/env bash
# Confirms each capstone answer file holds the correct value. Anything that
# depends on a custom function's exact return convention is re-derived with
# the same trusted expression rather than hardcoded.

set -u

FIXTURE="${HOME}/jp-capstone/context.json"
ANSWERS="${HOME}/jp-capstone/answers"

if [[ ! -f "$FIXTURE" ]]; then
  echo "FAIL: fixture $FIXTURE is missing"
  exit 1
fi

check_exact() {
  local name="$1" file="$2" expected="$3"
  if [[ ! -f "$file" ]]; then
    echo "FAIL: $name - $file does not exist"
    exit 1
  fi
  local actual
  actual=$(tr -d '\n' < "$file")
  if [[ "$actual" != "$expected" ]]; then
    echo "FAIL: $name - expected '$expected', got '$actual'"
    exit 1
  fi
}

check_dynamic() {
  local name="$1" file="$2" expr="$3"
  if [[ ! -f "$file" ]]; then
    echo "FAIL: $name - $file does not exist"
    exit 1
  fi
  local expected actual
  expected=$(kyverno jp query -i "$FIXTURE" -u "$expr" 2>/dev/null)
  actual=$(tr -d '\n' < "$file")
  if [[ "$actual" != "$expected" ]]; then
    echo "FAIL: $name - expected '$expected', got '$actual'"
    exit 1
  fi
}

check_exact "tag" "${ANSWERS}/tag.txt" "2.3.1"
check_dynamic "version-check" "${ANSWERS}/version-check.txt" "semver_compare(split(pod.spec.containers[0].image, ':')[1], minVersion)"
check_dynamic "selector-match" "${ANSWERS}/selector-match.txt" "label_match(requiredSelector, pod.metadata.labels)"
check_dynamic "owner-valid" "${ANSWERS}/owner-valid.txt" 'regex_match('"'"'^[^@]+@[^@]+\.[^@]+$'"'"', pod.metadata.annotations.owner)'

echo "PASS: all four kyverno jp capstone answers are correct."
exit 0
