#!/usr/bin/env bash
set -eu

mkdir -p "${HOME}/jp-lab/answers"

cat > "${HOME}/jp-lab/pod.json" <<'EOF'
{
  "apiVersion": "v1",
  "kind": "Pod",
  "metadata": {
    "name": "checkout-web-7f8c9",
    "namespace": "  checkout  ",
    "labels": {
      "team": "checkout",
      "environment": "PRODUCTION"
    }
  },
  "spec": {
    "containers": [
      { "name": "web", "image": "registry.example.com/checkout/web:1.4.2" },
      { "name": "sidecar", "image": "registry.example.com/checkout/envoy:1.28.0" }
    ]
  }
}
EOF

echo "Fixture written to ${HOME}/jp-lab/pod.json"
