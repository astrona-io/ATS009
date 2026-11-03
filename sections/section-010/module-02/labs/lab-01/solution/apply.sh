#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -eu

cd /root/toolbox-lab

KYVERNO_EXPERIMENTAL=true kyverno docs -o /root/toolbox-lab/reference --autogenTag=false
kyverno completion zsh > /root/toolbox-lab/_kyverno
ln -sf /usr/local/bin/kyverno /usr/local/bin/kubectl-kyverno

kyverno create test -p policy.yaml -r compliant-app.yaml -r legacy-app.yaml \
  --pass require-team-label,check-team-label,compliant-app,apps,Pod \
  --fail require-team-label,check-team-label,legacy-app,apps,Pod \
  -o scaffold-test.yaml

kyverno create user-info -u alice@example.com -g developers -c admin -o user-info.yaml
