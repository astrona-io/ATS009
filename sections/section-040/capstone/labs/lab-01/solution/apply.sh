#!/usr/bin/env bash
# Writes the reference answer files. Run only by `astrona test`.
set -euo pipefail

FIXTURE="${HOME}/jp-capstone/context.json"
ANSWERS="${HOME}/jp-capstone/answers"

kyverno jp query -i "$FIXTURE" -u "split(pod.spec.containers[0].image, ':')[1]" > "${ANSWERS}/tag.txt"
kyverno jp query -i "$FIXTURE" -u "semver_compare(split(pod.spec.containers[0].image, ':')[1], minVersion)" > "${ANSWERS}/version-check.txt"
kyverno jp query -i "$FIXTURE" -u "label_match(requiredSelector, pod.metadata.labels)" > "${ANSWERS}/selector-match.txt"
kyverno jp query -i "$FIXTURE" -u "regex_match('^[^@]+@[^@]+\\.[^@]+\$', pod.metadata.annotations.owner)" > "${ANSWERS}/owner-valid.txt"

echo "[solution] Applied."
