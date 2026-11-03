#!/usr/bin/env bash
# /root/toolbox-lab/_kyverno holds a zsh completion script for kyverno.

set -u

COMPLETION_FILE="/root/toolbox-lab/_kyverno"

if [[ ! -s "$COMPLETION_FILE" ]]; then
  echo "FAIL: $COMPLETION_FILE does not exist or is empty"
  exit 1
fi

if ! grep -Eiq 'compdef' "$COMPLETION_FILE"; then
  echo "FAIL: $COMPLETION_FILE has no compdef line, so it is not a zsh completion script"
  exit 1
fi

if ! grep -q 'kyverno' "$COMPLETION_FILE"; then
  echo "FAIL: $COMPLETION_FILE does not mention kyverno"
  exit 1
fi

echo "PASS: zsh completion script for kyverno found at $COMPLETION_FILE."
exit 0
