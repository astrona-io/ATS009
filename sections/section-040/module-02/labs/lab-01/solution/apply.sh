#!/usr/bin/env bash
# Writes the reference answer files. Run only by `astrona test`.
set -euo pipefail

D="${HOME}/jp-lab"
A="${D}/answers"

kyverno jp query -i "${D}/pods.json" -u 'max_by(items, &status.restarts).metadata.name' > "${A}/busiest-pod.txt"
kyverno jp query -i "${D}/pods.json" "length(items[?status.phase=='Running'])" > "${A}/running-count.txt"
kyverno jp query -i "${D}/pods.json" -c 'sort(keys(items[0].metadata.labels))' > "${A}/label-keys.txt"
kyverno jp query -i "${D}/settings.json" -u 'base64_decode(data.token)' > "${A}/token.txt"
kyverno jp query -i "${D}/settings.json" -u 'multiply(parse_json(data.limits).memory, `2`)' > "${A}/memory.txt"
kyverno jp query -i "${D}/settings.json" -u "time_since('', startedAt, '2024-03-01T12:30:00Z')" > "${A}/uptime.txt"

echo "[solution] Applied."
