#!/usr/bin/env bash
# Installs the kyverno CLI binary, matching the in-cluster Kyverno version.
set -eu

KYVERNO_CLI_VERSION="v1.13.2"

echo "Installing kyverno CLI ${KYVERNO_CLI_VERSION}..."
curl -sSL "https://github.com/kyverno/kyverno/releases/download/${KYVERNO_CLI_VERSION}/kyverno-cli_${KYVERNO_CLI_VERSION}_linux_x86_64.tar.gz" \
  -o /tmp/kyverno-cli.tar.gz
tar -xzf /tmp/kyverno-cli.tar.gz -C /usr/local/bin kyverno
rm -f /tmp/kyverno-cli.tar.gz
chmod +x /usr/local/bin/kyverno

kyverno version
