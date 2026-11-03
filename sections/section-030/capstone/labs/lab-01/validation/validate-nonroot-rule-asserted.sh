#!/usr/bin/env bash
# Takes the securityContext away from good-pod in a scratch copy. A suite that
# really asserts "pass" for check-runAsNonRoot must then fail.
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
  containers:
    - name: app
      image: nginx:1.25-alpine
YAML

cd "${scratch}"
if kyverno test . >/dev/null 2>&1; then
  echo "FAIL: the suite still passes when good-pod loses runAsNonRoot, so check-runAsNonRoot is not really asserted for it"
  exit 1
fi

echo "PASS: the suite notices when good-pod breaks check-runAsNonRoot."
