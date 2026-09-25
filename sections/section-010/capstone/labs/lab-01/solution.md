# Solution Walkthrough

Follow these steps to install a pinned CLI version, verify its integrity, and enable completion:

---

## Step 1: Download and install the pinned version

```sh
curl -LO https://github.com/kyverno/kyverno/releases/download/v1.13.2/kyverno-cli_v1.13.2_linux_x86_64.tar.gz
tar -xvf kyverno-cli_v1.13.2_linux_x86_64.tar.gz
sudo cp kyverno /usr/local/bin/
```

---

## Step 2: Verify integrity against the official release

GoReleaser-built projects like Kyverno publish a `checksums.txt` asset alongside every release. Download it and confirm your tarball's hash matches the published one before trusting the binary:

```sh
curl -LO https://github.com/kyverno/kyverno/releases/download/v1.13.2/checksums.txt
sha256sum kyverno-cli_v1.13.2_linux_x86_64.tar.gz
grep kyverno-cli_v1.13.2_linux_x86_64.tar.gz checksums.txt
```

The two hashes (the one you just computed, and the line for your asset inside `checksums.txt`) must match exactly. This is the same principle package managers automate for you — here you're doing it by hand.

---

## Step 3: Verify the version

```sh
kyverno version
```

Confirm the output contains `v1.13.2`.

---

## Step 4: Enable bash completion

```sh
kyverno completion bash | sudo tee /etc/bash_completion.d/kyverno > /dev/null
```

Open a new shell (or `source /etc/bash_completion.d/kyverno`) and confirm `kyverno <TAB>` now suggests subcommands.
