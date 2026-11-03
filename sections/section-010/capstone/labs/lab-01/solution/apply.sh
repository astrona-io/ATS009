#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -eu

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

cd "$WORK_DIR"
curl -sSLO https://github.com/kyverno/kyverno/releases/download/v1.13.2/kyverno-cli_v1.13.2_linux_x86_64.tar.gz
curl -sSLO https://github.com/kyverno/kyverno/releases/download/v1.13.2/checksums.txt
grep kyverno-cli_v1.13.2_linux_x86_64.tar.gz checksums.txt | sha256sum -c -
tar -xzf kyverno-cli_v1.13.2_linux_x86_64.tar.gz kyverno
cp kyverno /usr/local/bin/kyverno
chmod +x /usr/local/bin/kyverno

mkdir -p /etc/bash_completion.d
kyverno completion bash > /etc/bash_completion.d/kyverno
kyverno version
