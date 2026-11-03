#!/usr/bin/env bash
# Check: web-image.txt holds the image of the first container
# The CLI prints "# <expression>" before the result, so the answer file holds
# the expression and the answer. This script reads both, runs the saved
# expression again against the fixture and compares the result.
set -uo pipefail

FIXTURE="${HOME}/jp-lab/pod.json"
ANSWER="${HOME}/jp-lab/answers/web-image.txt"
EXPECTED='registry.example.com/checkout/web:1.4.2'
REQUIRED_FUNCTION=''

fail() {
  echo "FAIL: $1"
  exit 1
}

last_result_line() {
  grep -v '^#' | sed '/^[[:space:]]*$/d' | tail -n 1
}

[ -f "$FIXTURE" ] || fail "the fixture $FIXTURE is missing"
[ -f "$ANSWER" ] || fail "$ANSWER does not exist"

expression="$(grep -m1 '^# ' "$ANSWER" | sed 's/^# //')"
actual="$(last_result_line < "$ANSWER")"

[ -n "$expression" ] || fail "$ANSWER has no '# expression' line; save the output of kyverno jp query with a redirect"

if [ -n "$REQUIRED_FUNCTION" ] && ! printf '%s' "$expression" | grep -qF "$REQUIRED_FUNCTION"; then
  fail "the expression in $ANSWER does not use $REQUIRED_FUNCTION"
fi

rerun="$(kyverno jp query -i "$FIXTURE" -u "$expression" 2>/dev/null | last_result_line)"
if [ "$rerun" != "$actual" ]; then
  fail "running the saved expression again gives '$rerun', but $ANSWER holds '$actual'"
fi

if [ "$actual" != "$EXPECTED" ]; then
  fail "expected '$EXPECTED', got '$actual'"
fi

echo "PASS: web-image.txt holds the right answer"
exit 0
