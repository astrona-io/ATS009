# Question

Solve this question on: `terminal`

A fixture file is waiting for you at `~/jp-capstone/context.json` — a payload shaped like the kind of data a real policy's `preconditions`/`context` block would evaluate. An empty `~/jp-capstone/answers/` directory is ready for your output files. Use `kyverno jp query -u` for every step, and check each unfamiliar function's exact signature with `kyverno jp function <name>` before writing the expression that uses it.

1.  Extract just the version tag (not the full image reference) from `pod.spec.containers[0].image` using `split`, and save it to `~/jp-capstone/answers/tag.txt`.
2.  Use `semver_compare` to compare the tag from Step 1 against `minVersion`, and save the raw result to `~/jp-capstone/answers/version-check.txt`.
3.  Use `label_match` to confirm `pod.metadata.labels` satisfies `requiredSelector`, and save the boolean result to `~/jp-capstone/answers/selector-match.txt`.
4.  Use `regex_match` with the pattern `^[^@]+@[^@]+\.[^@]+$` to confirm `pod.metadata.annotations.owner` looks like a well-formed email address, and save the boolean result to `~/jp-capstone/answers/owner-valid.txt`.
