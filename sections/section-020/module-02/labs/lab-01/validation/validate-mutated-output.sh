#!/usr/bin/env bash
# The mutated Pod was written with -o: scout carries tier: standard and keeps app: scout.
set -u

out="/root/mutate-lab/scout-mutated.yaml"
source_file="/root/mutate-lab/scout.yaml"

if [[ ! -s "$out" ]]; then
  echo "FAIL: $out is missing or empty"
  exit 1
fi

if ! grep -Eq '^[[:space:]]*kind:[[:space:]]*Pod[[:space:]]*$' "$out"; then
  echo "FAIL: $out does not hold a Pod"
  exit 1
fi

if ! grep -Eq '^[[:space:]]*tier:[[:space:]]*"?standard"?[[:space:]]*$' "$out"; then
  echo "FAIL: $out does not hold the label tier: standard"
  exit 1
fi

if ! grep -Eq '^[[:space:]]*app:[[:space:]]*"?scout"?[[:space:]]*$' "$out"; then
  echo "FAIL: $out lost the original label app: scout"
  exit 1
fi

if grep -q "tier" "$source_file"; then
  echo "FAIL: the source file $source_file was changed; mutation must go to the output file only"
  exit 1
fi

echo "PASS: scout-mutated.yaml holds the patched Pod and the source file is untouched."
exit 0
