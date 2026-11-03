#!/usr/bin/env bash
# Seeds ~/kyverno-cli-lab with policies, resources, a values file, user info
# files and an exception, in shared folders. No test manifests: the learner
# writes them under tests/.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
mkdir -p "${LAB_DIR}/policies" "${LAB_DIR}/resources" "${LAB_DIR}/values" "${LAB_DIR}/userinfo"
cd "${LAB_DIR}"

cat <<'YAML' > policies/restrict-registry.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: restrict-registry
spec:
  validationFailureAction: Enforce
  background: false
  rules:
    - name: check-registry
      match:
        any:
          - resources:
              kinds:
                - Pod
      context:
        - name: registryConfig
          configMap:
            name: registry-config
            namespace: platform
      validate:
        message: "Images must come from the approved registry."
        pattern:
          spec:
            containers:
              - image: "{{ registryConfig.data.prefix }}/*"
YAML

cat <<'YAML' > policies/platform-admin-only.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: platform-admin-only
spec:
  validationFailureAction: Enforce
  background: false
  rules:
    - name: block-platform-tier
      match:
        any:
          - resources:
              kinds:
                - Pod
              selector:
                matchLabels:
                  tier: platform
      exclude:
        any:
          - clusterRoles:
              - cluster-admin
      validate:
        message: "Only cluster admins may create platform-tier Pods."
        deny: {}
YAML

cat <<'YAML' > policies/legacy-exception.yaml
apiVersion: kyverno.io/v2
kind: PolicyException
metadata:
  name: allow-legacy-pod
  namespace: default
spec:
  exceptions:
    - policyName: restrict-registry
      ruleNames:
        - check-registry
  match:
    any:
      - resources:
          kinds:
            - Pod
          names:
            - legacy-pod
YAML

cat <<'YAML' > resources/good-registry-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: good-registry-pod
spec:
  containers:
    - name: app
      image: registry.example.com/team/app:1.0
YAML

cat <<'YAML' > resources/bad-registry-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: bad-registry-pod
spec:
  containers:
    - name: app
      image: docker.io/library/nginx:1.25
YAML

cat <<'YAML' > resources/legacy-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: legacy-pod
spec:
  containers:
    - name: app
      image: docker.io/library/nginx:1.25
YAML

cat <<'YAML' > resources/platform-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: platform-pod
  labels:
    tier: platform
spec:
  containers:
    - name: app
      image: registry.example.com/team/app:1.0
YAML

cat <<'YAML' > values/registry-values.yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Values
policies:
  - name: restrict-registry
    rules:
      - name: check-registry
        values:
          registryConfig.data.prefix: registry.example.com
YAML

cat <<'YAML' > userinfo/admin.yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: UserInfo
metadata:
  name: admin-user
clusterRoles:
  - cluster-admin
userInfo:
  username: alice
YAML

cat <<'YAML' > userinfo/dev.yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: UserInfo
metadata:
  name: dev-user
clusterRoles:
  - edit
userInfo:
  username: bob
YAML

echo "Lab fixtures written to ${LAB_DIR}"
