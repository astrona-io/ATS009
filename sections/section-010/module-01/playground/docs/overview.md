# Overview: Installing & Verifying the Kyverno CLI (Playground)

This is a **playground**, not a lab. It starts a training solar system (a `kind` cluster) and then waits. There is no task, no `astrona submit` and no pass or fail. Install, check, break and remove the scanner as often as you like. `astrona destroy` and start over when you want a clean machine.

## What is in the box

- A `kind` cluster with the Kyverno controller `v1.13.2` running in the namespace `kyverno`.
- A terminal where you are the administrator (`root`), with `curl`, `tar` and `kubectl` ready.
- **No** `kyverno` command. Installing it is the exercise.

## Practice ideas

- Download the `v1.13.2` Linux `x86_64` release tarball, unpack it and copy the binary into `/usr/local/bin`. Then run `which kyverno` and `kyverno version`.
- Download `checksums.txt` next to the tarball and compare the checksum of your file with the published line.
- Put a second copy of the binary in a folder that comes earlier on your `PATH`, and use `which -a kyverno` to see which one wins. Then remove it again.
- Copy the binary under the name `kubectl-kyverno` and call it as `kubectl kyverno version`.
- Upgrade by replacing the file, then check the version again. Remove the binary and watch `command not found` return.
