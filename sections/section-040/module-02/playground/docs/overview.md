# Overview: Advanced JMESPath (Playground)

This is a playground, not a lab. It starts a training solar system and waits. There is no task, no `astrona submit` and no pass or fail. Reshape the data, break the expressions, read the errors, and `astrona destroy` when you are done.

## What is in the box

- The `kyverno` command-line tool, version `1.13.2`, in `/usr/local/bin`, and the Kyverno controller `v1.13.2` in the cluster. `kyverno jp` does not need the cluster.
- Three star charts in `~/jp-playground/`:

  | File | What it is |
  | --- | --- |
  | `pods.json` | A list of three Pods (`checkout-web-7f8c9`, `checkout-worker-5d4b2`, `legacy-batch-1a2b3`) with labels, a phase, a restart count and containers. Some keys contain dots and slashes. One Pod has no annotations |
  | `request.json` | One Pod inside an admission request, with `request.operation`, `request.userInfo` and `request.object` |
  | `settings.json` | A JSON document stored as a string, a base 64 token, a messy path and a start time |

Start in the right folder:

```sh
cd ~/jp-playground
```

## Ideas to try

- List the names of the Pods that are not `Running`, then the same names in upper case.
- Print one list with every container image of every Pod, and then only the images that start with `registry.example.com`.
- Build a list of small objects with the keys `name` and `restarts`, sorted by `restarts`.
- Read the owner annotation of every Pod with the key in quotes, then give the Pod without annotations the default `unknown`.
- Decode the token in `settings.json` and read the `memory` limit out of the JSON string.
- Ask the same question in `request.json` that a policy would ask: who sent the request, and what is the Pod's `team` label.
- Run `kyverno jp parse` on an expression you wrote and find the pipe and the function in the tree.
