# Question

Solve this question on: `terminal`

Astronaut, your mission: read a star chart with the navigation computer and write down each answer. A Pod file is waiting at `~/jp-lab/pod.json`, and an empty `~/jp-lab/answers/` folder is ready for your answer files. For every step, use `kyverno jp query` with the `-u` (unquoted) flag, so plain strings and booleans are written without extra quotes, and redirect the output straight into the named file.

1.  Query the Pod's `metadata.name` and save it to `~/jp-lab/answers/name.txt`.
2.  The `metadata.namespace` field has stray spaces at the start and the end. Use Kyverno's `trim` function to clean it, and save the result to `~/jp-lab/answers/namespace.txt`.
3.  The `environment` label is upper case (`PRODUCTION`), but the rest of this cluster's tooling expects lower case. Use `to_lower` to convert `metadata.labels.environment`, and save the result to `~/jp-lab/answers/environment.txt`.
4.  Extract only the `image` field of the **first** container (index `0`) in `spec.containers`, and save it to `~/jp-lab/answers/web-image.txt`.
5.  Use `kyverno jp function pattern_match` to check how the function works, then write an expression that checks whether the first container's image matches the wildcard pattern `registry.example.com/checkout/*`. Save the boolean result to `~/jp-lab/answers/pattern-check.txt`.

The grader compares each answer file with the expected value: `checkout-web-7f8c9`, `checkout`, `production`, `registry.example.com/checkout/web:1.4.2`, and the result of the same `pattern_match` expression run by the grader.
