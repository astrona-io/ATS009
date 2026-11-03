#!/usr/bin/env bash
# kyverno docs wrote the command reference into /root/toolbox-lab/reference.

set -u

DOCS_DIR="/root/toolbox-lab/reference"

for page in kyverno_apply.md kyverno_test.md; do
  if [[ ! -s "$DOCS_DIR/$page" ]]; then
    echo "FAIL: $DOCS_DIR/$page does not exist or is empty"
    exit 1
  fi
done

if ! grep -Eiq 'kyverno apply' "$DOCS_DIR/kyverno_apply.md"; then
  echo "FAIL: $DOCS_DIR/kyverno_apply.md does not look like the reference page for kyverno apply"
  exit 1
fi

echo "PASS: command reference pages found in $DOCS_DIR."
exit 0
