#!/usr/bin/env bash
# The generated ConfigMap was written with -o.
set -u

out="/root/mutate-lab/welcome-generated.yaml"

if [[ ! -s "$out" ]]; then
  echo "FAIL: $out is missing or empty"
  exit 1
fi

if ! grep -Eq '^[[:space:]]*kind:[[:space:]]*ConfigMap[[:space:]]*$' "$out"; then
  echo "FAIL: $out does not hold a ConfigMap"
  exit 1
fi

if ! grep -Eq '^[[:space:]]*name:[[:space:]]*welcome[[:space:]]*$' "$out"; then
  echo "FAIL: $out does not hold a ConfigMap named welcome"
  exit 1
fi

if ! grep -Eq '^[[:space:]]*namespace:[[:space:]]*"?venus"?[[:space:]]*$' "$out"; then
  echo "FAIL: the ConfigMap in $out is not in the namespace venus"
  exit 1
fi

if ! grep -Eq 'message:[[:space:]]*"?welcome-aboard"?' "$out"; then
  echo "FAIL: $out does not hold the data message: welcome-aboard"
  exit 1
fi

echo "PASS: welcome-generated.yaml holds the ConfigMap welcome for the namespace venus."
exit 0
