#!/usr/bin/env bash
# The installed file is the real Kyverno CLI: its help lists the subcommands.

set -u

if ! command -v kyverno >/dev/null 2>&1; then
  echo "FAIL: 'kyverno' is not on PATH"
  exit 1
fi

if ! help_output="$(kyverno help 2>&1)"; then
  echo "FAIL: 'kyverno help' exited with an error"
  exit 1
fi

for subcommand in apply test jp version; do
  if ! echo "$help_output" | grep -Eiq "^[[:space:]]+${subcommand}[[:space:]]"; then
    echo "FAIL: 'kyverno help' does not list the '${subcommand}' subcommand"
    exit 1
  fi
done

echo "PASS: kyverno help lists apply, test, jp and version."
exit 0
