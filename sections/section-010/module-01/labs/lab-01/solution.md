# Solution Walkthrough

Three steps: download the right crate, put the binary on your tool rack, then read its serial plate. The last step is the one the grader cares about.

---

## Step 1: Download the release tarball

Download the asset for version `v1.13.2`, Linux, `x86_64`:

```sh
curl -LO https://github.com/kyverno/kyverno/releases/download/v1.13.2/kyverno-cli_v1.13.2_linux_x86_64.tar.gz
```

Release assets follow the pattern `kyverno-cli_v{VERSION}_{OS}_{ARCH}.tar.gz`. The version, the system and the processor type must match exactly. A wrong name points at a file that does not exist, and GitHub answers with a "Not Found" page instead of the archive.

---

## Step 2: Unpack and install

Unpack the archive and copy the binary into `/usr/local/bin`:

```sh
tar -xvf kyverno-cli_v1.13.2_linux_x86_64.tar.gz
sudo cp kyverno /usr/local/bin/
```

The archive holds two files, `LICENSE` and a binary named `kyverno`. `/usr/local/bin` is already on the `PATH` in this lab, so you do not need to change `PATH`.

---

## Step 3: Verify

Ask the shell which file it runs, then read the version:

```sh
which kyverno
kyverno version
```

```text
/usr/local/bin/kyverno
Version: 1.13.2
Time: 2024-12-10T08:37:07Z
Git commit ID: a96b1a4794b4d25cb0c6d72c05fc6355e95cf65c
```

The version line shows `1.13.2`, with no `v` in front. The build time and the commit are fixed for this release, so yours match.

If you get `command not found` instead, check that the binary is in a folder on your `PATH` (`echo $PATH`) and that it may run (`sudo chmod +x /usr/local/bin/kyverno`).

---

## Submit

Send the mission for grading:

```sh
astrona submit -c sections/section-010/module-01/labs/lab-01
```
