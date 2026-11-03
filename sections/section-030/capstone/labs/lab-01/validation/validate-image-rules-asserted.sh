#!/usr/bin/env bash
# Gives good-pod the :latest tag in a scratch copy. A suite that really asserts
# "pass" for validate-image-tag must then fail.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
[[ -f "${LAB_DIR}/kyverno-test.yaml" ]] || { echo "FAIL: kyverno-test.yaml not found"; exit 1; }

scratch=$(mktemp -d)
trap 'rm -rf "${scratch}"' EXIT
cp -R "${LAB_DIR}/." "${scratch}/"

cat <<'YAML' > "${scratch}/good-pod.yaml"
apiVersion: v1
kind: Pod
metadata:
  name: good-pod
spec:
  securityContext:
    runAsNonRoot: true
  containers:
    - name: app
      image: nginx:latest
YAML

cd "${scratch}"
if kyverno test . >/dev/null 2>&1; then
  echo "FAIL: the suite still passes when good-pod uses :latest, so validate-image-tag is not really asserted for it"
  exit 1
fi

echo "PASS: the suite notices when good-pod breaks validate-image-tag."
