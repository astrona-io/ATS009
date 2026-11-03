#!/usr/bin/env bash
set -eu

kubectl create namespace apps --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace platform --dry-run=client -o yaml | kubectl apply -f -

# A real ConfigMap the policy's context will read from once applied live —
# unlike the offline apply step, this doesn't need to be mocked.
kubectl -n platform create configmap registry-config \
  --from-literal=registry=registry.internal/ \
  --dry-run=client -o yaml | kubectl apply -f -

mkdir -p /root/apply-capstone
cat <<'EOF' > /root/apply-capstone/policy.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: check-registry-cm
spec:
  validationFailureAction: Enforce
  background: true
  rules:
    - name: check-registry
      match:
        any:
        - resources:
            kinds:
              - Pod
            namespaces:
              - apps
      context:
        - name: approvedRegistry
          configMap:
            name: registry-config
            namespace: platform
      validate:
        message: "Container images must start with {{ approvedRegistry.data.registry }}"
        pattern:
          spec:
            containers:
            - image: "{{ approvedRegistry.data.registry }}*"
EOF

cat <<'EOF' > /root/apply-capstone/good-img.yaml
apiVersion: v1
kind: Pod
metadata:
  name: trusted-app
  namespace: apps
spec:
  containers:
    - name: app
      image: registry.internal/app:2.0
EOF

cat <<'EOF' > /root/apply-capstone/bad-img.yaml
apiVersion: v1
kind: Pod
metadata:
  name: untrusted-app
  namespace: apps
spec:
  containers:
    - name: app
      image: docker.io/library/nginx:alpine
EOF

cat <<'EOF' > /root/apply-capstone/values.yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Values
globalValues:
  "approvedRegistry.data.registry": "registry.internal/"
EOF

echo "apply-capstone fixtures ready in /root/apply-capstone; registry-config ConfigMap live in platform."
