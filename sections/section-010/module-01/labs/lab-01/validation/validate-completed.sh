#!/usr/bin/env bash
# Confirms the kyverno CLI is installed, on PATH, executable, and reports v1.13.2.

set -u

KYVERNO_BIN="$(command -v kyverno 2>/dev/null)"
if [[ -z "$KYVERNO_BIN" ]]; then
  echo "FAIL: kyverno CLI installed - 'kyverno' is not on PATH"
  exit 1
fi

if [[ ! -x "$KYVERNO_BIN" ]]; then
  echo "FAIL: kyverno CLI installed - '$KYVERNO_BIN' exists but is not executable"
  exit 1
fi

version_output=$("$KYVERNO_BIN" version 2>/dev/null)
if [[ -z "$version_output" ]]; then
  echo "FAIL: kyverno CLI installed - 'kyverno version' produced no output or failed to run"
  exit 1
fi

if ! echo "$version_output" | grep -q "v1.13.2"; then
  echo "FAIL: kyverno CLI installed - 'kyverno version' does not report v1.13.2"
  echo "--- kyverno version output ---"
  echo "$version_output"
  exit 1
fi

echo "PASS: kyverno CLI found at $KYVERNO_BIN, executable, and reports v1.13.2."
exit 0
