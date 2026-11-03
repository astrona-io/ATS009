# Overview: JMESPath with the Kyverno CLI (Playground)

This is a playground, not a lab. It starts a training solar system and waits. There is no task, no `astrona submit` and no pass or fail. Ask the navigation computer questions, make mistakes, read the errors, and `astrona destroy` when you are done.

## What is in the box

- The `kyverno` command-line tool, version `1.13.2`, in `/usr/local/bin`. `kyverno jp` never needs a cluster, but the Kyverno controller `v1.13.2` is installed too, so the environment looks like the graded missions.
- One star chart, `~/jp-playground/pod.json`: a cut-down Pod named `checkout-web-7f8c9` with the labels `team` and `environment`, a namespace written with spaces around it, and two containers called `web` and `sidecar`.

Start in the right folder:

```sh
cd ~/jp-playground
```

## Ideas to try

- Print the Pod's `team` label with quotes, then without quotes.
- Print the names of both containers on one line.
- Ask for the name of the third container and read what comes back.
- Save one expression in a file, run it with `-q`, and then pipe the same file in through standard input.
- Compare a label with `'checkout'` and then with a backtick literal, and read both results.
- List the functions with `kyverno jp function`, count them, and read the manual of two functions you have not used.
