#!/usr/bin/env bash
# Check: owner-valid.txt holds the regex_match result for the owner annotation
# The CLI prints "# <expression>" before the result, so the answer file holds
# the expression and the answer. This script reads both, runs the saved
# expression again against the fixture and compares the result.
set -uo pipefail

FIXTURE="${HOME}/jp-capstone/context.json"
ANSWER="${HOME}/jp-capstone/answers/owner-valid.txt"
EXPECTED='true'
REQUIRED_FUNCTION='regex_match('

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

echo "PASS: owner-valid.txt holds the right answer"
exit 0
