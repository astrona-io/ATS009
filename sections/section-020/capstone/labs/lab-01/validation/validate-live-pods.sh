#!/usr/bin/env bash
# trusted-app runs with a registry.internal/ image; untrusted-app was turned away.
set -u

trusted_image=$(kubectl -n apps get pod trusted-app -o jsonpath='{.spec.containers[0].image}' 2>/dev/null || true)

if [[ -z "$trusted_image" ]]; then
  echo "FAIL: trusted-app not found in apps; it should have been admitted"
  exit 1
fi

if [[ "$trusted_image" != registry.internal/* ]]; then
  echo "FAIL: trusted-app has image '$trusted_image', expected a registry.internal/ image"
  exit 1
fi

if kubectl -n apps get pod untrusted-app >/dev/null 2>&1; then
  echo "FAIL: untrusted-app exists in apps; check-registry-cm should have blocked it"
  exit 1
fi

echo "PASS: trusted-app is admitted and untrusted-app does not exist."
exit 0
