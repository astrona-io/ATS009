#!/usr/bin/env bash
# Gives batch-pod the label that the mutate rule selects, in a scratch copy. A
# suite that really claims "skip" for it must then fail.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
[[ -f "${LAB_DIR}/kyverno-test.yaml" ]] || { echo "FAIL: kyverno-test.yaml not found"; exit 1; }
[[ -f "${LAB_DIR}/batch-pod.yaml" ]] || { echo "FAIL: batch-pod.yaml not found"; exit 1; }

scratch=$(mktemp -d)
trap 'rm -rf "${scratch}"' EXIT
cp -R "${LAB_DIR}/." "${scratch}/"

cat <<'YAML' > "${scratch}/batch-pod.yaml"
apiVersion: v1
kind: Pod
metadata:
  name: batch-pod
  labels:
    tier: web
spec:
  containers:
    - name: app
      image: busybox:1.36
YAML

cd "${scratch}"
if kyverno test . >/dev/null 2>&1; then
  echo "FAIL: the suite still passes when batch-pod matches the rule, so the skip claim for it is not really asserted"
  exit 1
fi

echo "PASS: the suite notices when batch-pod stops being skipped."
