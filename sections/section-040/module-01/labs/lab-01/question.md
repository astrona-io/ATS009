# Question

Solve this question on: `terminal`

A fixture file is waiting for you at `~/jp-lab/pod.json`. An empty `~/jp-lab/answers/` directory is ready for your output files. For every step below, use `kyverno jp query` with the `-u` (unquoted) flag so plain strings and booleans are written without extra quoting, and redirect the output straight into the named file.

1.  Query the Pod's `metadata.name` and save it to `~/jp-lab/answers/name.txt`.
2.  The `metadata.namespace` field has stray leading/trailing whitespace baked into the fixture. Use the `trim` function to clean it and save the result to `~/jp-lab/answers/namespace.txt`.
3.  The `environment` label is uppercase (`PRODUCTION`), but the rest of this cluster's tooling expects lowercase. Use `to_lower` to convert `metadata.labels.environment` and save the result to `~/jp-lab/answers/environment.txt`.
4.  Extract just the `image` field of the **first** container (index `0`) in `spec.containers` and save it to `~/jp-lab/answers/web-image.txt`.
5.  Use `kyverno jp function pattern_match` to confirm how the function works, then write an expression that checks whether the first container's image matches the glob pattern `registry.example.com/checkout/*`. Save the boolean result to `~/jp-lab/answers/pattern-check.txt`.
