#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
cd "${LAB_DIR}"

cat <<'YAML' > kyverno-test.yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: policy-tests
policies:
  - require-run-as-nonroot.yaml
resources:
  - good-pod.yaml
  - bad-pod.yaml
results:
  - policy: require-run-as-nonroot
    rule: check-runAsNonRoot
    resources:
      - good-pod
    kind: Pod
    result: pass
  - policy: require-run-as-nonroot
    rule: check-runAsNonRoot
    resources:
      - bad-pod
    kind: Pod
    result: fail
YAML
echo "[solution] kyverno-test.yaml written."
