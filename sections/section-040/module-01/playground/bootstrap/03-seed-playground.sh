#!/usr/bin/env bash
set -eu

mkdir -p "${HOME}/jp-playground"

cat > "${HOME}/jp-playground/pod.json" <<'JSON'
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
JSON

echo "Playground file written to ${HOME}/jp-playground/pod.json"
