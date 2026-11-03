#!/usr/bin/env bash
# The kyverno binary is found on PATH and may run.

set -u

KYVERNO_BIN="$(command -v kyverno 2>/dev/null || true)"
if [[ -z "$KYVERNO_BIN" ]]; then
  echo "FAIL: 'kyverno' is not on PATH"
  exit 1
fi

if [[ ! -x "$KYVERNO_BIN" ]]; then
  echo "FAIL: '$KYVERNO_BIN' exists but is not executable"
  exit 1
fi

echo "PASS: kyverno found at $KYVERNO_BIN and executable."
exit 0
