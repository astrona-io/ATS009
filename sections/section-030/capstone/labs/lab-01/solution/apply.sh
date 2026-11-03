#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
cd "${LAB_DIR}"

cat <<'YAML' > kyverno-test.yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: capstone-tests
policies:
  - require-run-as-nonroot.yaml
  - disallow-latest-tag.yaml
resources:
  - good-pod.yaml
  - bad-nonroot-pod.yaml
  - bad-image-pod.yaml
  - bad-both-pod.yaml
results:
  - policy: require-run-as-nonroot
    rule: check-runAsNonRoot
    resources:
      - good-pod
      - bad-image-pod
    kind: Pod
    result: pass
  - policy: require-run-as-nonroot
    rule: check-runAsNonRoot
    resources:
      - bad-nonroot-pod
      - bad-both-pod
    kind: Pod
    result: fail
  - policy: disallow-latest-tag
    rule: require-image-tag
    resources:
      - good-pod
      - bad-nonroot-pod
      - bad-image-pod
      - bad-both-pod
    kind: Pod
    result: pass
  - policy: disallow-latest-tag
    rule: validate-image-tag
    resources:
      - good-pod
      - bad-nonroot-pod
    kind: Pod
    result: pass
  - policy: disallow-latest-tag
    rule: validate-image-tag
    resources:
      - bad-image-pod
      - bad-both-pod
    kind: Pod
    result: fail
YAML
echo "[solution] kyverno-test.yaml written."
