#!/usr/bin/env bash
set -eu

mkdir -p "${HOME}/jp-playground"

cat > "${HOME}/jp-playground/pods.json" <<'JSON'
{
  "apiVersion": "v1",
  "kind": "List",
  "items": [
    {
      "metadata": {
        "name": "checkout-web-7f8c9",
        "namespace": "checkout",
        "labels": { "team": "checkout", "app.kubernetes.io/name": "web", "tier": "frontend" },
        "annotations": { "example.com/owner": "checkout-team@example.com" }
      },
      "spec": {
        "containers": [
          { "name": "web", "image": "registry.example.com/checkout/web:1.4.2", "resources": { "limits": { "cpu": "500m", "memory": "256Mi" } } },
          { "name": "sidecar", "image": "registry.example.com/checkout/envoy:1.28.0" }
        ]
      },
      "status": { "phase": "Running", "restarts": 0 }
    },
    {
      "metadata": {
        "name": "checkout-worker-5d4b2",
        "namespace": "checkout",
        "labels": { "team": "checkout", "app.kubernetes.io/name": "worker", "tier": "backend" }
      },
      "spec": {
        "containers": [
          { "name": "worker", "image": "registry.example.com/checkout/worker:2.0.1", "resources": { "limits": { "cpu": "1", "memory": "512Mi" } } }
        ]
      },
      "status": { "phase": "Running", "restarts": 3 }
    },
    {
      "metadata": {
        "name": "legacy-batch-1a2b3",
        "namespace": "legacy",
        "labels": { "team": "platform", "tier": "backend" }
      },
      "spec": {
        "containers": [
          { "name": "batch", "image": "docker.io/library/busybox:latest" }
        ]
      },
      "status": { "phase": "Pending", "restarts": 1 }
    }
  ]
}
JSON

cat > "${HOME}/jp-playground/request.json" <<'JSON'
{
  "request": {
    "operation": "CREATE",
    "userInfo": { "username": "ci-deployer", "groups": ["system:serviceaccounts", "ci"] },
    "object": {
      "kind": "Pod",
      "metadata": {
        "name": "checkout-web-7f8c9",
        "namespace": "checkout",
        "labels": { "team": "checkout", "app.kubernetes.io/name": "web" }
      },
      "spec": {
        "containers": [
          { "name": "web", "image": "registry.example.com/checkout/web:1.4.2" }
        ]
      }
    }
  }
}
JSON

cat > "${HOME}/jp-playground/settings.json" <<'JSON'
{
  "data": {
    "limits": "{\"cpu\":\"500m\",\"memory\":\"256Mi\"}",
    "token": "Y2hlY2tvdXQtdG9rZW4="
  },
  "path": "/apps/../checkout//web/",
  "startedAt": "2024-03-01T10:00:00Z"
}
JSON

echo "Playground files written to ${HOME}/jp-playground"
