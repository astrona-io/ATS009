# Solution Walkthrough

Follow these steps to install and verify the CLI:

---

## Step 1: Download the release tarball

```sh
curl -LO https://github.com/kyverno/kyverno/releases/download/v1.13.2/kyverno-cli_v1.13.2_linux_x86_64.tar.gz
```

Release assets follow the pattern `kyverno-cli_v{VERSION}_{OS}_{ARCH}.tar.gz` — matching the version, OS, and architecture exactly matters, since a mismatched asset simply won't exist at that URL (you'll get a 404).

---

## Step 2: Extract and install

```sh
tar -xvf kyverno-cli_v1.13.2_linux_x86_64.tar.gz
sudo cp kyverno /usr/local/bin/
```

The extracted archive contains a binary literally named `kyverno`. `/usr/local/bin` is on `PATH` by default on this lab image, so copying it there is enough — no `PATH` edits needed.

---

## Step 3: Verify

```sh
kyverno version
```

Expect output containing:
```text
Version: v1.13.2
Time: ...
Git commit: ...
Go version: ...
```

If `command not found` appears instead, double check the binary landed in a directory that's actually on your `PATH` (`echo $PATH`) and that it's executable (`chmod +x /usr/local/bin/kyverno`).
