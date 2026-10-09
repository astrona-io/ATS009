# Question

Solve this question on: `terminal`

Astronaut, your capstone mission: install a scanner you can prove is genuine, and make the console finish its commands for you. This training solar system (a `kind` cluster) already runs the Kyverno controller `v1.13.2`. The Kyverno command-line interface (CLI) is **not** installed.

1.  Install the Kyverno CLI, pinned exactly to `v1.13.2`, Linux `x86_64`, from the official GitHub release tarball. The installed `kyverno` binary must be the unchanged binary from that release.
2.  Confirm that `kyverno version` reports version `1.13.2`.
3.  Generate a bash completion script for `kyverno` and save it at `/etc/bash_completion.d/kyverno`.

The grader downloads the official `v1.13.2` release itself and compares its binary, byte for byte, with the `kyverno` on your `PATH`. It also reads `kyverno version` and checks that a non-empty completion script for `kyverno` exists.
