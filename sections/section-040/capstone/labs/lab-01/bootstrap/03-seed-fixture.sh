#!/usr/bin/env bash
set -eu

mkdir -p "${HOME}/jp-capstone/answers"

cat > "${HOME}/jp-capstone/context.json" <<'EOF'
{
  "pod": {
    "metadata": {
      "labels": { "team": "payments", "tier": "backend" },
      "annotations": { "owner": "platform-team@example.com" }
    },
    "spec": {
      "containers": [
        { "name": "api", "image": "registry.example.com/payments/api:2.3.1" }
      ]
    }
  },
  "requiredSelector": { "team": "payments" },
  "minVersion": "2.0.0"
}
EOF

echo "Fixture written to ${HOME}/jp-capstone/context.json"
