# Question

Solve this question on: `terminal`

Astronaut, your capstone mission: answer four questions a real policy would ask, using Kyverno's extra instruments. A file is waiting at `~/jp-capstone/context.json`, shaped like the data a policy's `preconditions` or `context` block works with. An empty `~/jp-capstone/answers/` folder is ready for your answer files. Use `kyverno jp query -u` for every step, and check each unfamiliar function's exact signature with `kyverno jp function <name>` before you write the expression that uses it.

1.  Extract only the version tag (not the full image reference) from `pod.spec.containers[0].image` using `split`, and save it to `~/jp-capstone/answers/tag.txt`.
2.  Use `semver_compare` to compare the tag from step 1 with `minVersion`, and save the raw result to `~/jp-capstone/answers/version-check.txt`.
3.  Use `label_match` to check whether `pod.metadata.labels` satisfies `requiredSelector`, and save the boolean result to `~/jp-capstone/answers/selector-match.txt`.
4.  Use `regex_match` with the pattern `^[^@]+@[^@]+\.[^@]+$` to check whether `pod.metadata.annotations.owner` looks like a well-formed email address, and save the boolean result to `~/jp-capstone/answers/owner-valid.txt`.

The grader expects `2.3.1` in `tag.txt`, and for the other three files it runs the same `semver_compare`, `label_match` and `regex_match` expressions itself and compares your file with its own result.
