# Question

Solve this question on: `terminal`

Astronaut, your mission: put the handheld rulebook scanner on board. This training solar system (a `kind` cluster) already runs the Kyverno controller `v1.13.2` in the namespace `kyverno`. The Kyverno command-line interface (CLI), the `kyverno` binary, is **not** installed.

1.  Download the Kyverno CLI release tarball for version `v1.13.2`, Linux, `x86_64`, from the official Kyverno GitHub releases.
2.  Unpack the archive and install the `kyverno` binary into a folder on your `PATH`, for example `/usr/local/bin`.
3.  Make sure the binary may run, and that `kyverno version` runs and reports version `1.13.2`.

The grader looks up `kyverno` on the `PATH`, checks that the file may run, and reads the output of `kyverno version`.
