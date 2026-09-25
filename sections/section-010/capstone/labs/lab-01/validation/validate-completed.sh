#!/usr/bin/env bash
# Confirms the installed kyverno binary is bit-identical to the official v1.13.2
# release artifact (proving integrity, independent of how the learner verified
# it) and that bash completion has been generated for the command.

set -u

KYVERNO_VERSION="v1.13.2"

KYVERNO_BIN="$(command -v kyverno 2>/dev/null)"
if [[ -z "$KYVERNO_BIN" ]]; then
  echo "FAIL: capstone - 'kyverno' is not on PATH"
  exit 1
fi

version_output=$("$KYVERNO_BIN" version 2>/dev/null)
if ! echo "$version_output" | grep -q "$KYVERNO_VERSION"; then
  echo "FAIL: capstone - 'kyverno version' does not report $KYVERNO_VERSION"
  exit 1
fi

echo "Re-downloading the official release artifact to verify integrity..."
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT
curl -sSL -o "$tmpdir/kyverno-cli.tar.gz" \
  "https://github.com/kyverno/kyverno/releases/download/${KYVERNO_VERSION}/kyverno-cli_${KYVERNO_VERSION}_linux_x86_64.tar.gz"
tar -xzf "$tmpdir/kyverno-cli.tar.gz" -C "$tmpdir" kyverno

official_sum=$(sha256sum "$tmpdir/kyverno" | awk '{print $1}')
installed_sum=$(sha256sum "$KYVERNO_BIN" | awk '{print $1}')

if [[ "$official_sum" != "$installed_sum" ]]; then
  echo "FAIL: capstone - installed binary checksum ($installed_sum) does not match the official ${KYVERNO_VERSION} release ($official_sum)"
  exit 1
fi

completion_found=""
for candidate in /etc/bash_completion.d/kyverno /usr/share/bash-completion/completions/kyverno "$HOME/.bash_completion.d/kyverno"; do
  if [[ -s "$candidate" ]] && grep -q "kyverno" "$candidate"; then
    completion_found="$candidate"
    break
  fi
done

if [[ -z "$completion_found" ]]; then
  echo "FAIL: capstone - no non-empty kyverno bash completion script found in the expected locations"
  exit 1
fi

echo "PASS: kyverno $KYVERNO_VERSION installed and byte-identical to the official release; bash completion found at $completion_found."
exit 0
