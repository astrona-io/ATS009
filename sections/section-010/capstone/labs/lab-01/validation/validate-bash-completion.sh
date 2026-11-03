#!/usr/bin/env bash
# /etc/bash_completion.d/kyverno holds a bash completion script for kyverno.

set -u

COMPLETION_FILE="/etc/bash_completion.d/kyverno"

if [[ ! -s "$COMPLETION_FILE" ]]; then
  echo "FAIL: $COMPLETION_FILE does not exist or is empty"
  exit 1
fi

if ! grep -Eiq 'bash completion|__start_kyverno' "$COMPLETION_FILE"; then
  echo "FAIL: $COMPLETION_FILE does not look like a bash completion script for kyverno"
  exit 1
fi

if ! grep -q 'kyverno' "$COMPLETION_FILE"; then
  echo "FAIL: $COMPLETION_FILE does not mention kyverno"
  exit 1
fi

echo "PASS: bash completion script for kyverno found at $COMPLETION_FILE."
exit 0
