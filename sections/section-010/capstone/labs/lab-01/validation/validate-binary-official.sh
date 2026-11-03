#!/usr/bin/env bash
# The kyverno on PATH is byte for byte the binary from the official v1.13.2 release.

set -u

KYVERNO_VERSION="v1.13.2"

KYVERNO_BIN="$(command -v kyverno 2>/dev/null || true)"
if [[ -z "$KYVERNO_BIN" ]]; then
  echo "FAIL: 'kyverno' is not on PATH"
  exit 1
fi

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

if ! curl -fsSL -o "$tmpdir/kyverno-cli.tar.gz" \
  "https://github.com/kyverno/kyverno/releases/download/${KYVERNO_VERSION}/kyverno-cli_${KYVERNO_VERSION}_linux_x86_64.tar.gz"; then
  echo "FAIL: the grader could not download the official ${KYVERNO_VERSION} release"
  exit 1
fi
tar -xzf "$tmpdir/kyverno-cli.tar.gz" -C "$tmpdir" kyverno

official_sum="$(sha256sum "$tmpdir/kyverno" | awk '{print $1}')"
installed_sum="$(sha256sum "$KYVERNO_BIN" | awk '{print $1}')"

if [[ "$official_sum" != "$installed_sum" ]]; then
  echo "FAIL: the installed binary ($installed_sum) is not the official ${KYVERNO_VERSION} binary ($official_sum)"
  exit 1
fi

echo "PASS: the installed kyverno is byte for byte the official ${KYVERNO_VERSION} binary."
exit 0
