# Section 010 Knowledge Check: Installing Kyverno CLI

Test your understanding of Kyverno CLI installation methods, verification, and CLI structure.

---

## Scenario-Based Questions

### Question 1
You installed the Kyverno CLI through Krew (`kubectl krew install kyverno`). Which command correctly verifies the install?
*   **A)** `kyverno version`
*   **B)** `kubectl kyverno version`
*   **C)** `kubectl-kyverno --version`
*   **D)** `kubectl get kyverno version`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** Krew installs the binary as `kubectl-kyverno`, which `kubectl` recognizes as a plugin invokable via `kubectl kyverno <subcommand>`. That is the invocation form this install method produces.
*   **Why others are incorrect:**
    *   *Option A* is the invocation form for a standalone install (release tarball or Homebrew), not Krew — the bare `kyverno` binary wouldn't be on `PATH` from a Krew install.
    *   *Option C* invents a flag; Kyverno's `version` is a subcommand (`kyverno version` / `kubectl kyverno version`), not a top-level `--version` flag.
    *   *Option D* is not a real command — Kyverno is not a Kubernetes API resource you `kubectl get`, it's a CLI plugin.
</details>

---

### Question 2
You run `kyverno apply` and get `command not found`. `ls /usr/local/bin/kyverno` shows the file exists. What is the most likely cause?
*   **A)** The Kyverno controller is not installed in the cluster.
*   **B)** `/usr/local/bin` is not in your shell's `PATH`, or the file is not marked executable.
*   **C)** `kyverno apply` requires a `--cluster` flag to even be recognized as a subcommand.
*   **D)** The CLI version does not match the in-cluster controller version.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `command not found` is a shell resolution error, not a Kyverno error — it means your shell couldn't find an executable named `kyverno` anywhere in `PATH`, even though the file exists at a known location. Either that directory isn't on `PATH`, or the file lacks execute permission (`chmod +x`).
*   **Why others are incorrect:**
    *   *Option A* is irrelevant — `kyverno apply` and `kyverno version` don't need a cluster at all; this error happens before Kyverno's own code ever runs.
    *   *Option C* is wrong — subcommands are recognized regardless of flags; omitting `--cluster` just changes behavior, it doesn't cause a "not found" shell error.
    *   *Option D* would produce a Kyverno-level error or behavior mismatch, not a shell `command not found`.
</details>

---

### Question 3
You need to pin an exact Kyverno CLI version in a CI pipeline's setup step, on a Linux x86_64 runner, without relying on a package manager being preinstalled. Which approach is most appropriate?
*   **A)** `brew install kyverno`, since Homebrew ships with every Linux distribution by default.
*   **B)** `kubectl krew install kyverno`, since Krew is guaranteed to be preinstalled on CI runners.
*   **C)** Download the exact `kyverno-cli_v{VERSION}_linux_x86_64.tar.gz` release asset with `curl`, extract it, and place the binary on `PATH`.
*   **D)** `go install github.com/kyverno/kyverno/cmd/cli/kubectl-kyverno@latest`, since `@latest` always resolves to a reproducible, pinned version.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: C**

*   **Why C is correct:** Downloading the exact versioned release tarball via `curl` has no external dependency beyond `curl` and `tar` (both near-universal on CI runners), and pins an exact, reproducible version — exactly what a CI setup step needs.
*   **Why others are incorrect:**
    *   *Option A* is false — Homebrew is not preinstalled on Linux by default and would need its own bootstrap step, adding fragility.
    *   *Option B* is false — Krew is a `kubectl` plugin manager that itself must be installed first; nothing guarantees its presence on a fresh CI runner.
    *   *Option D* is wrong on two counts: `@latest` resolves to whatever the newest commit/tag is at build time — the opposite of pinned and reproducible — and this only works with a Go toolchain present, another unguaranteed dependency.
</details>

---

### Question 4
What is the actual relationship between the Kyverno CLI version and the Kyverno controller version running in a cluster?
*   **A)** They must always be identical, or `kyverno apply --cluster` will refuse to run.
*   **B)** They are independent — `kyverno apply` and `kyverno test` work entirely offline with no cluster at all, though keeping versions aligned avoids behavior drift between what the CLI simulates and what the live admission controller enforces.
*   **C)** The CLI reads its own version from the cluster's Kyverno controller at every invocation.
*   **D)** There is no controller version to compare against — only the CLI is versioned.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** The CLI is a standalone binary that simulates policy evaluation locally; it does not require a live cluster to run `apply` or `test`. Version alignment with an in-cluster controller is a best practice for behavioral consistency, not a hard requirement enforced by the tooling.
*   **Why others are incorrect:**
    *   *Option A* invents an enforcement mechanism that doesn't exist — `--cluster` mode evaluates real cluster objects but does not version-gate against the controller.
    *   *Option C* is wrong — the CLI's version is fixed at build time, not fetched dynamically per invocation.
    *   *Option D* is wrong — the in-cluster Kyverno controller (installed via `install.yaml` or Helm) is independently versioned, exactly like the CLI.
</details>

---

### Question 5
Which subcommand would you run to see the full, authoritative flag list for `kyverno apply` on the exact CLI version you have installed, without leaving your terminal or trusting possibly-outdated web documentation?
*   **A)** `kyverno docs apply`
*   **B)** `kyverno apply --help`
*   **C)** `man kyverno-apply`
*   **D)** `kyverno version --flags`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** Every Kyverno subcommand supports `--help`, which prints flags generated directly from the binary you have installed — guaranteed to match your exact version, unlike a web page that may document a different release.
*   **Why others are incorrect:**
    *   *Option A* invents a subcommand; `docs` is not how per-command help is retrieved in this CLI.
    *   *Option C* assumes a man page ships with the binary, which Kyverno's CLI does not install.
    *   *Option D* invents a flag on the wrong subcommand — `version` reports build metadata, not other subcommands' flags.
</details>

---

### Question 6
You run `kyverno completion bash > /etc/bash_completion.d/kyverno` after installing the CLI. What does this accomplish?
*   **A)** It upgrades the CLI to the latest version automatically.
*   **B)** It generates a shell completion script so `<TAB>` will suggest subcommands and flags for the `kyverno` command.
*   **C)** It installs the `kubectl kyverno` plugin form in addition to the standalone binary.
*   **D)** It verifies the CLI's checksum against the official release.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `completion` is a standard Cobra-CLI subcommand that emits a shell script teaching your shell's completion system about `kyverno`'s subcommands and flags — a pure quality-of-life feature with no effect on the binary itself.
*   **Why others are incorrect:**
    *   *Option A* is unrelated — completion scripts don't touch the installed binary at all.
    *   *Option C* is unrelated — the plugin form is a separate binary (`kubectl-kyverno`) installed through a different method (Krew or building from source).
    *   *Option D* is unrelated — checksum verification is a manual integrity check against release artifacts, not something `completion` performs.
</details>
