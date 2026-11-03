# Question

Solve this question on: `terminal`

Astronaut, your mission: ask the navigation computer about a whole fleet and write down each answer. Three files are waiting in `~/jp-lab/`: `pods.json` (three Pods), `request.json` and `settings.json`. An empty `~/jp-lab/answers/` folder is ready for your answer files. Use `kyverno jp query -i <file>` and redirect the output straight into the named file. Use `kyverno jp function <name>` if you are not sure about a signature.

1.  In `pods.json`, find the name of the Pod with the most restarts (`status.restarts`) using `max_by`. Save the name to `~/jp-lab/answers/busiest-pod.txt`.
2.  Count the Pods whose `status.phase` is `Running`, using `length` and a filter. Save the number to `~/jp-lab/answers/running-count.txt`.
3.  List the label keys of the first Pod (`items[0]`), sorted, using `keys` and `sort`. Save the list to `~/jp-lab/answers/label-keys.txt`. Use the `-c` flag so the list is on one line.
4.  In `settings.json`, decode `data.token` with `base64_decode` and save it to `~/jp-lab/answers/token.txt`.
5.  The key `data.limits` holds a string of JSON. Open it with `parse_json`, take its `memory` value and double it with `multiply`. Save the result to `~/jp-lab/answers/memory.txt`.
6.  Use `time_since` to measure the time between `startedAt` and the moment `2024-03-01T12:30:00Z`. Save the result to `~/jp-lab/answers/uptime.txt`.

`kyverno jp query` prints the expression as a `#` comment line before the result, so every answer file holds the expression and the result. That is expected. The grader reads the comment line, runs that expression again against the matching file, and checks the result. It ignores spaces and double quotes in the result. It also checks that each step really uses `max_by`, `length`, `sort`, `base64_decode`, `multiply` and `time_since`.

The expected values are `checkout-worker-5d4b2`, `2`, `["app.kubernetes.io/name","team","tier"]`, `checkout-token`, `512Mi` and `2h30m0s`.
