#!/usr/bin/env bash
# Confirms each kyverno jp query answer file holds the correct value. The
# pattern-check answer is re-derived with the same trusted expression rather
# than hardcoded, since it depends on a custom function's exact behavior.

set -u

FIXTURE="${HOME}/jp-lab/pod.json"
ANSWERS="${HOME}/jp-lab/answers"

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

check_exact "name" "${ANSWERS}/name.txt" "checkout-web-7f8c9"
check_exact "namespace" "${ANSWERS}/namespace.txt" "checkout"
check_exact "environment" "${ANSWERS}/environment.txt" "production"
check_exact "web-image" "${ANSWERS}/web-image.txt" "registry.example.com/checkout/web:1.4.2"

if [[ ! -f "${ANSWERS}/pattern-check.txt" ]]; then
  echo "FAIL: pattern-check - ${ANSWERS}/pattern-check.txt does not exist"
  exit 1
fi
expected_pattern=$(kyverno jp query -i "$FIXTURE" -u "pattern_match('registry.example.com/checkout/*', spec.containers[0].image)" 2>/dev/null)
actual_pattern=$(tr -d '\n' < "${ANSWERS}/pattern-check.txt")
if [[ "$actual_pattern" != "$expected_pattern" ]]; then
  echo "FAIL: pattern-check - expected '$expected_pattern', got '$actual_pattern'"
  exit 1
fi

echo "PASS: all five kyverno jp query answers are correct."
exit 0
