#!/usr/bin/env bash
# Repairs bad-pod in a scratch copy. A suite that really asserts "fail" for
# bad-pod must then fail, because the claim is no longer true.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
[[ -f "${LAB_DIR}/kyverno-test.yaml" ]] || { echo "FAIL: kyverno-test.yaml not found"; exit 1; }

scratch=$(mktemp -d)
trap 'rm -rf "${scratch}"' EXIT
cp -R "${LAB_DIR}/." "${scratch}/"

cat <<'YAML' > "${scratch}/bad-pod.yaml"
apiVersion: v1
kind: Pod
metadata:
  name: bad-pod
spec:
  securityContext:
    runAsNonRoot: true
  containers:
    - name: app
      image: nginx:alpine
YAML

cd "${scratch}"
if kyverno test . >/dev/null 2>&1; then
  echo "FAIL: the suite still passes when bad-pod is repaired, so it does not really assert that bad-pod fails"
  exit 1
fi

echo "PASS: the suite notices when bad-pod stops failing the rule."
