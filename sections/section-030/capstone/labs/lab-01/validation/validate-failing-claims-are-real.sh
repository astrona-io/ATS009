#!/usr/bin/env bash
# Repairs bad-both-pod in a scratch copy. A suite that really asserts "fail"
# for it under two rules must then fail.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
[[ -f "${LAB_DIR}/kyverno-test.yaml" ]] || { echo "FAIL: kyverno-test.yaml not found"; exit 1; }

scratch=$(mktemp -d)
trap 'rm -rf "${scratch}"' EXIT
cp -R "${LAB_DIR}/." "${scratch}/"

cat <<'YAML' > "${scratch}/bad-both-pod.yaml"
apiVersion: v1
kind: Pod
metadata:
  name: bad-both-pod
spec:
  securityContext:
    runAsNonRoot: true
  containers:
    - name: app
      image: nginx:1.25-alpine
YAML

cd "${scratch}"
if kyverno test . >/dev/null 2>&1; then
  echo "FAIL: the suite still passes when bad-both-pod is repaired, so the fail claims for it are not really asserted"
  exit 1
fi

echo "PASS: the suite notices when bad-both-pod stops failing."
