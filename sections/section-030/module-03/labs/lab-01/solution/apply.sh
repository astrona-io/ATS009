#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
cd "${LAB_DIR}"
mkdir -p tests/registry tests/platform-admin tests/platform-dev

cat <<'YAML' > tests/registry/kyverno-test.yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: registry-tests
policies:
  - ../../policies/restrict-registry.yaml
resources:
  - ../../resources/good-registry-pod.yaml
  - ../../resources/bad-registry-pod.yaml
  - ../../resources/legacy-pod.yaml
exceptions:
  - ../../policies/legacy-exception.yaml
variables: ../../values/registry-values.yaml
results:
  - policy: restrict-registry
    rule: check-registry
    resources:
      - good-registry-pod
    kind: Pod
    result: pass
  - policy: restrict-registry
    rule: check-registry
    resources:
      - bad-registry-pod
    kind: Pod
    result: fail
  - policy: restrict-registry
    rule: check-registry
    resources:
      - legacy-pod
    kind: Pod
    result: skip
YAML

cat <<'YAML' > tests/platform-admin/kyverno-test.yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: platform-admin-tests
policies:
  - ../../policies/platform-admin-only.yaml
resources:
  - ../../resources/platform-pod.yaml
userinfo: ../../userinfo/admin.yaml
results:
  - policy: platform-admin-only
    rule: block-platform-tier
    resources:
      - platform-pod
    kind: Pod
    result: skip
YAML

cat <<'YAML' > tests/platform-dev/kyverno-test.yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: platform-dev-tests
policies:
  - ../../policies/platform-admin-only.yaml
resources:
  - ../../resources/platform-pod.yaml
userinfo: ../../userinfo/dev.yaml
results:
  - policy: platform-admin-only
    rule: block-platform-tier
    resources:
      - platform-pod
    kind: Pod
    result: fail
YAML
echo "[solution] three test manifests written under tests/."
