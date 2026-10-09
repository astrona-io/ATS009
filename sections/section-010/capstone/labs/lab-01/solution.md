# Solution Walkthrough

Four steps: install the pinned version, check the crate's seal against the shipping papers, read the version, then write the completion script.

---

## Step 1: Download and install the pinned version

Download the `v1.13.2` asset for Linux `x86_64`, unpack it, and copy the binary onto your `PATH`:

```sh
curl -LO https://github.com/kyverno/kyverno/releases/download/v1.13.2/kyverno-cli_v1.13.2_linux_x86_64.tar.gz
tar -xvf kyverno-cli_v1.13.2_linux_x86_64.tar.gz
sudo cp kyverno /usr/local/bin/
```

Copy the binary exactly as it came out of the archive. The grader compares it byte for byte with the official one, so a rebuilt or changed binary fails.

---

## Step 2: Check the download against the release checksums

Every Kyverno release publishes a `checksums.txt` file next to its assets. It lists a SHA-256 checksum for each asset: think of it as the seal number printed on the shipping papers. Download it, compute the checksum of your tarball, and find the line for your asset:

```sh
curl -LO https://github.com/kyverno/kyverno/releases/download/v1.13.2/checksums.txt
sha256sum kyverno-cli_v1.13.2_linux_x86_64.tar.gz
grep kyverno-cli_v1.13.2_linux_x86_64.tar.gz checksums.txt
```

```text
c0a85e8d8e855a879ddabbf19568fd80c3095a46f3f686cd4d2653cf0ab6601f  kyverno-cli_v1.13.2_linux_x86_64.tar.gz
c0a85e8d8e855a879ddabbf19568fd80c3095a46f3f686cd4d2653cf0ab6601f  kyverno-cli_v1.13.2_linux_x86_64.tar.gz
```

The first line is the checksum you computed. The second is the one the release published. They must match exactly. This is the same check a package manager does for you; here you do it by hand.

---

## Step 3: Verify the version

Read the scanner's serial plate:

```sh
kyverno version
```

```text
Version: 1.13.2
Time: 2024-12-10T08:37:07Z
Git commit ID: a96b1a4794b4d25cb0c6d72c05fc6355e95cf65c
```

The binary reports `1.13.2`, with no `v` in front.

---

## Step 4: Enable bash completion

Generate the bash completion script and write it into `/etc/bash_completion.d/`. Writing there needs administrator rights, so pipe the script through `sudo tee`:

```sh
kyverno completion bash | sudo tee /etc/bash_completion.d/kyverno > /dev/null
```

Then check that the file is there and is a bash completion script:

```sh
head -1 /etc/bash_completion.d/kyverno
```

```text
# bash completion V2 for kyverno                              -*- shell-script -*-
```

Open a new shell, or run `source /etc/bash_completion.d/kyverno`, then type `kyverno ` and press `<TAB>`. The shell now offers the subcommands.

---

## Submit

Send the mission for grading:

```sh
astrona submit -c sections/section-010/capstone/labs/lab-01
```
