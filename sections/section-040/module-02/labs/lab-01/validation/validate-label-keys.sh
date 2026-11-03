#!/usr/bin/env bash
# Check: label-keys.txt 
# The CLI prints "# <expression>" before the result, so the answer file holds
# the expression and the answer. This script reads both, runs the saved
# expression again against the fixture and compares the result.
set -uo pipefail

FIXTURE="${HOME}/jp-lab/pods.json"
ANSWER="${HOME}/jp-lab/answers/label-keys.txt"
EXPECTED='[app.kubernetes.io/name,team,tier]'  # spaces and double quotes are removed before comparing
REQUIRED_FUNCTION='sort('

fail() {
  echo "FAIL: $1"
  exit 1
}

# All result lines, without comments, blanks, spaces and double quotes.
result_text() {
  grep -v '^#' | tr -d ' \t\r\n"'
}

[ -f "$FIXTURE" ] || fail "the fixture $FIXTURE is missing"
[ -f "$ANSWER" ] || fail "$ANSWER does not exist"

expression="$(grep -m1 '^# ' "$ANSWER" | sed 's/^# //')"
actual="$(result_text < "$ANSWER")"

[ -n "$expression" ] || fail "$ANSWER has no '# expression' line; save the output of kyverno jp query with a redirect"

if [ -n "$REQUIRED_FUNCTION" ] && ! printf '%s' "$expression" | grep -qF "$REQUIRED_FUNCTION"; then
  fail "the expression in $ANSWER does not use $REQUIRED_FUNCTION"
fi

rerun="$(kyverno jp query -i "$FIXTURE" -c "$expression" 2>/dev/null | result_text)"
if [ "$rerun" != "$actual" ]; then
  fail "running the saved expression again gives '$rerun', but $ANSWER holds '$actual'"
fi

if [ "$actual" != "$EXPECTED" ]; then
  fail "expected '$EXPECTED', got '$actual'"
fi

echo "PASS: label-keys.txt holds the right answer"
exit 0
