#!/usr/bin/env bash
# kubectl finds a kubectl-kyverno plugin and it reports 1.13.2.

set -u

if ! command -v kubectl-kyverno >/dev/null 2>&1; then
  echo "FAIL: no executable named 'kubectl-kyverno' on the PATH"
  exit 1
fi

if ! plugin_output="$(kubectl kyverno version 2>&1)"; then
  echo "FAIL: 'kubectl kyverno version' exited with an error"
  echo "$plugin_output"
  exit 1
fi

if ! echo "$plugin_output" | grep -Eiq 'version:[[:space:]]*v?1\.13\.2([[:space:]]|$)'; then
  echo "FAIL: 'kubectl kyverno version' does not report 1.13.2"
  echo "$plugin_output"
  exit 1
fi

echo "PASS: kubectl kyverno version reports 1.13.2."
exit 0
