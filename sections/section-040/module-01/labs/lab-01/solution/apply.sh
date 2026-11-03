#!/usr/bin/env bash
# Writes the reference answer files. Run only by `astrona test`.
set -euo pipefail

FIXTURE="${HOME}/jp-lab/pod.json"
ANSWERS="${HOME}/jp-lab/answers"

kyverno jp query -i "$FIXTURE" -u 'metadata.name' > "${ANSWERS}/name.txt"
kyverno jp query -i "$FIXTURE" -u "trim(metadata.namespace, ' ')" > "${ANSWERS}/namespace.txt"
kyverno jp query -i "$FIXTURE" -u 'to_lower(metadata.labels.environment)' > "${ANSWERS}/environment.txt"
kyverno jp query -i "$FIXTURE" -u 'spec.containers[0].image' > "${ANSWERS}/web-image.txt"
kyverno jp query -i "$FIXTURE" -u "pattern_match('registry.example.com/checkout/*', spec.containers[0].image)" > "${ANSWERS}/pattern-check.txt"

echo "[solution] Applied."
