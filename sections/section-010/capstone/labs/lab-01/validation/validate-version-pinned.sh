#!/usr/bin/env bash
# kyverno version runs and reports 1.13.2 (the 1.13.2 binary prints no "v").

set -u

if ! command -v kyverno >/dev/null 2>&1; then
  echo "FAIL: 'kyverno' is not on PATH"
  exit 1
fi

if ! version_output="$(kyverno version 2>&1)"; then
  echo "FAIL: 'kyverno version' exited with an error"
  echo "$version_output"
  exit 1
fi

if ! echo "$version_output" | grep -Eiq 'version:[[:space:]]*v?1\.13\.2([[:space:]]|$)'; then
  echo "FAIL: 'kyverno version' does not report 1.13.2"
  echo "--- kyverno version output ---"
  echo "$version_output"
  exit 1
fi

echo "PASS: kyverno version reports 1.13.2."
exit 0
