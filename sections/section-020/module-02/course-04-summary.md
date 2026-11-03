# Summary

Well done, astronaut. You can now preview a repair, preview a new base, and tell the simulator who is asking. Look back at what you learned, check yourself, and clean up.

## What you learned

**From [Mutating Resources And Saving The Result](./course-01-mutating-resources-and-saving-the-result.md):**

- A `mutate` rule changes a resource. `kyverno apply` shows the patched resource and writes it to the file you name with `-o`.
- `apply` never edits the source file.
- The `+(key)` add anchor fills a gap and leaves an existing value alone.
- `-i`/`--stdin` is meant for piping the result on. For scripts, write a file with `-o` and apply that file.

**From [Generating Resources From A Trigger](./course-02-generating-resources-from-a-trigger.md):**

- A `generate` rule builds a new resource when a trigger resource appears. Offline, you pass the trigger with `--resource`.
- `{{request.object.metadata.name}}` is the name of the trigger. It places the generated resource on the right planet.
- `apply` writes the result with `-o` and creates nothing in the cluster.
- Clone rules need a cluster to read the source.

**From [Request Data: User Info, Operation And Namespace Labels](./course-03-request-data-user-info-operation-and-namespace-labels.md):**

- `-u`/`--userinfo` gives the CLI a made-up requester (`clusterRoles`, `userInfo.username`), so `match` and `exclude` blocks with roles can be checked.
- `request.operation` and namespace labels come from `--set` or a values file (`namespaceSelector`).
- The exit code tells a script whether the rule passed.

## Your mission

You proved the skill in a graded mission, right after the part that taught it:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Mutate & Generate Apply Lab](./labs/lab-01/README.md) | Request Data: User Info, Operation And Namespace Labels | save a mutated Pod with `-o`, generate a `ConfigMap`, pass a user info file, and apply the repaired Pod |

If you skipped it, go back to it now.

## Check yourself

<details>
<summary>1. You ran a mutate rule with <code>-o</code>, but <code>grep</code> shows the source file has no new label. Is something wrong?</summary>

No. `apply` never changes the source. The patched resource is in the `-o` file.
</details>

<details>
<summary>2. A Pod already has <code>team: checkout</code>. Your rule uses <code>+(team): unassigned</code>. What is the label afterwards?</summary>

Still `checkout`. The add anchor only adds the label when it is missing.
</details>

<details>
<summary>3. You ran a generate rule with <code>apply</code>. Does the <code>ConfigMap</code> exist in the cluster?</summary>

No. `apply` only writes the result. Create it with `kubectl` or let a Kyverno controller do it.
</details>

<details>
<summary>4. A policy lets only the role <code>flight-director</code> through, and your offline run fails. What do you add?</summary>

A user info file with that role under `clusterRoles`, passed with `-u`.
</details>

<details>
<summary>5. How do you test a rule that only reacts to <code>UPDATE</code> requests?</summary>

Set `request.operation` with `--set request.operation=UPDATE` or in a values file.
</details>

## Clean up

The playground is a whole Kubernetes cluster running on your machine. Remove it, and any mission that is still running.

```sh
astrona list
```

If the playground or a mission is still listed, remove it. The command takes the **name**, not the folder path:

```sh
astrona destroy ats-009-playground-020-02
```

> *Preview the repair, preview the base, and show your badge, all before the real ship docks.*

<!-- astrona:playground:destroy -->
