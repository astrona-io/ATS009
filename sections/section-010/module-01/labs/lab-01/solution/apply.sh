#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -eu

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

cd "$WORK_DIR"
curl -sSLO https://github.com/kyverno/kyverno/releases/download/v1.13.2/kyverno-cli_v1.13.2_linux_x86_64.tar.gz
tar -xzf kyverno-cli_v1.13.2_linux_x86_64.tar.gz kyverno
cp kyverno /usr/local/bin/kyverno
chmod +x /usr/local/bin/kyverno
kyverno version
