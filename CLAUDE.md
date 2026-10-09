# Writing style for this repo

All study text here (course pages, lab docs, READMEs, comments in YAML and
scripts) is for people learning a technical subject, often for a
certification exam. Many of them are not native English speakers and have no
university degree.

## Plain English

Write the text in Plain English for a general adult audience (18+) without a
university degree. The content must be highly accessible and easy to
understand for non-technical readers, without feeling childish.

Strict guidelines:

1. Target a Flesch-Kincaid Grade Level of 8 or 9 (equivalent to a standard
   newspaper article).
2. Avoid all technical jargon, acronyms, and corporate buzzwords. If a
   technical term is necessary, explain it immediately using an everyday
   analogy.
3. Keep sentences conversational and direct. Split long sentences into two.
4. Use short paragraphs (max 3-4 sentences per paragraph) and clear
   subheadings to make the text scannable.
5. Use the active voice (e.g., "We did this" instead of "This was done by us").

## How this applies to course material

- **Know which file you are in.** A module has a short landing page and a few
  deep-dive parts. The landing page is a map: goals, what to know first, the
  order of the parts, where it fits. The real teaching goes in the parts. A lab
  has a task, a step-by-step solution and a short intro. Keep each file to its
  job. Do not add "Prerequisite: ... Next: ..." navigation lines to pages;
  the landing page and the course outline already give the order.
- **Keep each part short.** One idea per part, about 5 to 8 minutes of
  reading and at most about 8 command blocks, so a learner can finish it with
  the playground in one sitting of about 15 minutes. Split at a natural seam
  where each half ends with something the learner has seen work. Never split
  only to hit a number. When you split, renumber the files, fix every "Part N"
  reference in the module, the wrap-up links and `astrona.yaml`.
- **Every heading gets an intro.** A `##` section that has `###`
  subsections starts with one to three sentences that say what the section
  is about and why it matters, before the first `###`. Never put a `###`
  directly under a `##`.
- **Every module stands on its own.** Never refer to other sections or
  modules: no "see section 040", "as module 3 showed", "you met this in
  section 000", and no links to pages in another module. If the reader needs
  a fact from elsewhere, state the fact directly in one or two sentences.
  This also goes for parts of the same module: never write "Part 2 shows",
  "from Part 1" or "as in Part 3". Say the fact itself ("the commands below
  need the `require-team-label` policy saved as `policy.yaml`"). The wrap-up page is the one
  exception: it recaps each part and links to it.
  The landing page does not have a "Where this fits" section.
- **Write words out in full.** Do not use informal short forms in prose:
  write "communications", "configuration", "repository", "administrator",
  "for example" and "that is", never "comms", "config", "repo", "admin",
  "e.g." or "i.e.". Names in code, commands and file paths stay as they are.
- **Exam terms stay.** The product's own names are what the reader must learn
  (for example a resource kind, a field, a command). Keep them, but explain
  each one in plain words, with an everyday analogy, the first time it appears
  in a file. Spell out acronyms on first use, with a short plain meaning.
- **Analogies come from space, and the reader is an astronaut.** When a term
  needs an everyday picture, use space: spaceships, planets, solar systems,
  space stations, mission control, signals, docking, star charts, airlocks,
  even the Death Star. Talk to the reader as an astronaut (for example "your
  first mission", "astronaut, check your flight log"), but not in every
  sentence. Requests are **signals** that ships send to each other. Use one
  analogy per hard idea, keep it short, and keep it the same everywhere (if
  the repository has an analogy glossary, use it). The analogy helps the reader; it
  never replaces the real term, and it never changes code or output.
- **Show one real example before the rule.** Start with a concrete case the
  reader can run, then give the general rule.
- **Say which part does the work.** Readers often mix up the parts of a system
  that sit close together. Whenever something happens, say which component
  did it.
- **Never change code to fit the style.** Commands, configuration files, field
  names, resource names, log lines and command output stay exactly as they
  are. They were run and checked on a real system. Never make up command
  output. If you shorten it, say that you did.
- **Prose only.** The grade-level and sentence rules apply to explanations.
  They do not apply to code blocks, tables of field names or reference lists
  (those may stay short and dense).
- **Keep the page furniture the same.** Hands-on steps are normal page
  content, not boxes: a short `###` subsection (for example "See it in your
  playground") with one sentence saying what to do, the command, the real
  output, and one or two sentences saying what it shows. A `> [!TIP]` box is
  only for a real tip: advice the reader can reuse beyond this one step (a
  habit, a shortcut, how to spot a problem, an exam habit). Everything else
  is a normal sentence: notes about the current step ("if the log line is
  old, run it again"), background facts, optional extra steps, and plain
  information. Never a command snippet, never two in a row, and most pages
  need zero or one tip. Each part ends with a
  `## Common pitfalls` `> [!WARNING]` block for that part only. Use a Mermaid
  diagram for a flow, an order or a state change, keep it under about 12
  boxes, and follow it with one sentence that says what it shows.
- **Labs come right after the part they practise.** Do not collect all
  graded labs at the end of a module. In `astrona.yaml`, put each lab (its
  `question.md` reading and the `lab` entry) right after the reading part it
  tests. If a part teaches a gradeable skill and no lab covers it, create a
  new lab. That part then ends with a `## Your mission: <lab title>` section:
  one sentence on what the reader can now do, one on what the mission asks,
  then pause the playground (`astrona stop <playground name>`), the
  `astrona run` and `astrona submit` commands, and finally
  `astrona destroy <lab name>` plus `astrona start <playground name>`. The
  wrap-up lists the missions and ends with cleaning up the playground
  (`astrona list`, `astrona destroy <playground name>`).
- **Renew the playground before hands-on work.** Every reading part that
  runs commands has `<!-- astrona:playground:renew -->` exactly once, on its
  own line, right before the first hands-on step (the first "Save this as"
  or the first command block), so the playground timer is reset before the
  learner needs the playground. Not on landing pages (they carry
  `<!-- astrona:playground -->`), wrap-up pages or pages without commands.
- **Mermaid without HTML.** The platform renders Mermaid with HTML labels
  switched off, so `<br/>` and any other HTML tag break the drawing. Rules:
  - One line per box, no `<br/>`, no HTML. Keep the box to the thing's name
    (`"kyverno apply"`, `"policy.yaml"`, `"API server"`).
  - Put the logic on the arrows: `A -->|"--resource"| R`,
    `C -->|"exit 0"| M`, `T -->|"result: fail"| F`. Keep edge labels short.
  - Quote every label. Prefer `flowchart TB`; use `LR` only for a short chain.
  - Sequence diagrams: short participant aliases (`participant K as kyverno`)
    and short message text.
  - Anything longer (cluster names, full hostnames) goes in the sentence under
    the diagram.
- **No links to outside sources.** Course pages, labs and playground docs do
  not link to or point at outside websites (the one exception is the
  `resources` field of a lab entry in `astrona.yaml`) (official docs, GitHub, blogs,
  RFCs), and they have no "Reference" or "Official docs" lists. Everything the
  reader needs is explained on the page itself. Not affected: addresses the
  reader actually uses in a command or browser (`kubectl create -f https://...`,
  `curl -LO https://github.com/kyverno/kyverno/releases/download/...`), and the Mission Briefing's contributors and
  "report a mistake" links.
- **Configuration goes to a file first.** Whenever the reader should apply
  YAML (course parts, playground docs, labs), use three separate steps:
  1. "Save this as `clusterpolicy-require-team-label.yaml`:" followed by a plain
     ` ```yaml ` block with only the YAML. No `cat > file <<'EOF'`, no
     `kubectl apply -f - <<EOF`, no shell around it.
  2. "Apply it:" followed by a ` ```sh ` block with only
     `kubectl apply -f clusterpolicy-require-team-label.yaml`.
  3. "Then check the result:" followed by the check commands, if any.
  The file name says the kind and the object. If a value must come from the
  reader's cluster (an IP address), use a placeholder like `<PARTNER>` in the
  YAML and say how to get the value (`echo $PARTNER`); never put shell
  variables inside YAML. Apply an object the first time its YAML appears; do
  not show it once "to read" and paste it again later. Never tell the reader
  to apply something from the playground's `examples/` folder: they start the
  playground with `astrona run`, so that folder is not on their machine.
- **Helpers have readable names.** Shell helper functions and variables use
  names that say what they do (`check_answer`, `run_suite`,
  `$POLICY_FILE`), never single letters.

## About this repo (ATS009 only)

Everything above is general and can be copied to other course repositories. This
section is only true for this one.

### What the student is trying to learn

- **The goal:** pass the **Kyverno CLI** domain of the **Kyverno Certified
  Associate (KCA)** exam. The Linux Foundation lists it at 12% of the exam.
  `astrona.yaml` records the same weight.
- **What the exam really tests:** using the `kyverno` command-line tool, not
  just knowing its name. The student must get the binary onto a machine,
  prove which version it is, test policies against resource files with no
  cluster, write a test suite that states the expected results, and debug a
  JMESPath expression from the terminal. Every explanation should lead to a
  command they can run and an output they can read.
- **The four exam topics (curriculum items):** installing the Kyverno CLI,
  `kyverno apply`, `kyverno test` and `kyverno jp`. The course follows that
  order, one section per topic.
- **The sections:**

  | Section | Title | Exam topic |
  | --- | --- | --- |
  | 010 | Installing Kyverno CLI | Installing Kyverno CLI |
  | 020 | kyverno apply | apply |
  | 030 | kyverno test | test |
  | 040 | kyverno jp | jp |

  The final domain quiz (`sections/final-domain-quiz.md`) covers all four.
- **The version:** every lab installs the Kyverno controller **v1.13.2**
  from `https://github.com/kyverno/kyverno/releases/download/v1.13.2/install.yaml`
  and, from section 020 on, the **v1.13.2** CLI from the
  `kyverno-cli_v1.13.2_linux_x86_64.tar.gz` release asset. Teach the 1.13.2
  behaviour. When a page mentions a flag or function that only newer CLIs
  have, say so in the sentence (see the environment facts below).
- **The main sources:** the Kyverno CLI page
  <https://kyverno.io/docs/subprojects/kyverno-cli/> and the generated
  command reference under <https://kyverno.io/docs/kyverno-cli/reference/kyverno/>.
  The most reliable source of all is the installed binary itself:
  `kyverno <command> --help` and `kyverno jp function <name>`. Check every
  page against them.

### Space analogy glossary

Use these pictures for these terms, in every course page, lab and quiz.
Keep them consistent so the astronaut builds one picture of the universe.
Most pages written before these rules have no space analogies yet; add them
when you rework a page, using this table.

**The universe**

| Term | Space picture |
| --- | --- |
| The learner | An astronaut (a cadet on their first missions) |
| Kubernetes cluster | A solar system |
| Namespace | A planet in that solar system |
| Pod | A spaceship |
| Container | A module inside the ship (the app is the crew) |
| Label | A marking painted on the ship's hull |
| Container image / registry | The ship's build plan / the shipyard that keeps the plans |
| Kubernetes API server | Mission control's front desk: every request to build or change a ship arrives here |
| `kind` cluster in a lab | A training solar system in the simulator |
| Your terminal and shell | The cockpit console |
| `PATH` | The tool rack the console searches when you call a tool by name |

**Kyverno in the solar system**

| Term | Space picture |
| --- | --- |
| Kyverno (the controller in the cluster) | The docking inspector at the spaceport: every new ship is checked before it may dock |
| Admission webhook | The inspection checkpoint every docking request passes through |
| `ClusterPolicy` / `Policy` | A page of the fleet rulebook, for the whole solar system / for one planet |
| Rule | One line on that page |
| `match` / `exclude` | Which ships the rule looks at / which ships it waves through |
| `validate` rule with a `pattern` | A template the ship's papers must fit |
| `Enforce` / `Audit` | Turn the ship away / let it dock but write it in the log |
| Background scan | The inspector's patrol past ships that docked before the rule existed |
| Policy report (`PolicyReport`, `ClusterPolicyReport`) | The inspection log, written up as a formal report |
| `context` entry (`configMap`, `apiCall`) | Information the inspector radios mission control for during an inspection |
| Autogen rules | Copies of a ship rule that Kyverno writes for the shipyards that build ships (Deployments, CronJobs) |

**The Kyverno CLI**

| Term | Space picture |
| --- | --- |
| Kyverno CLI (`kyverno` binary) | A handheld rulebook scanner: the inspector's own checking logic, working offline in your hand |
| `kubectl kyverno` (Krew plugin) | The same scanner clipped onto your standard toolbelt (`kubectl`) |
| Release tarball | A sealed supply crate from the shipyard |
| `checksums.txt` / SHA-256 | The seal number printed on the shipping papers; you compare it with the crate's seal |
| Shell completion | The console's autocomplete: it finishes command words as you type |
| `kyverno version` | Reading the serial plate on the scanner |
| `kyverno apply` (offline) | A dry run in the simulator: inspect ship blueprints (YAML files) with no real ship docking |
| `--cluster` | Pointing the scanner at ships that are already docked in a live solar system |
| Resource file | A ship's blueprint on paper |
| `pass` / `fail` / `warn` / `error` / `skip` | Cleared / turned away / cleared with a warning note / the scanner could not finish reading the rule / the rule does not apply to this ship |
| Values file (`-f`) / `--set` | A prepared answer sheet, so the scanner does not need to radio mission control |
| `kyverno test` / `kyverno-test.yaml` | The pre-flight checklist with the expected answer next to every line, and the run that compares them |
| `results` entry | One checklist line: this rule, these ships, this expected verdict |
| Exit code | The green or red light on the console when a check ends (`0` is green) |
| CI pipeline | The launch checklist every change must clear before it leaves the shipyard |
| JMESPath | The star-chart query language: how you point at one exact star in a chart (a JSON document) |
| `kyverno jp query` | The navigation computer: give it a chart and a question, it reads back the answer |
| Projection `[*]` / filter `[?...]` / pipe `\|` | Ask every ship in the squadron at once / only ships that fit a condition / hand the answer to the next station |
| Raw string `'text'` / JSON literal `` `9` `` | Plain words in single quotes / a coded value (number, true or false, list) in backticks |
| Kyverno custom functions | Extra instruments Kyverno adds to the navigation computer |
| `kyverno jp function` | The instrument manual, printed by the instrument itself |

### The sample apps the labs use

This course has **no playgrounds** and no shared fleet. Each graded lab
brings its own small set of files and Pods. Use these names exactly as the
bootstrap scripts create them; never rename them in the text.

| Lab | What the bootstrap creates |
| --- | --- |
| 010 lab and capstone | Only the Kyverno controller in namespace `kyverno`. The CLI is **not** installed: installing it is the task |
| 020 lab | Namespace `apps` with Pods `compliant-app` (label `team: checkout`) and `legacy-app` (no `team` label); files in `/root/apply-lab/`: `policy.yaml` (`ClusterPolicy` `require-team-label`, rule `check-team-label`, `Enforce`), `compliant-app.yaml`, `legacy-app.yaml` |
| 020 capstone | Namespaces `apps` and `platform`; `ConfigMap` `registry-config` in `platform` with `registry: registry.internal/`; files in `/root/apply-capstone/`: `policy.yaml` (`ClusterPolicy` `check-registry-cm`, rule `check-registry`, `context` entry `approvedRegistry`), `good-img.yaml` (Pod `trusted-app`), `bad-img.yaml` (Pod `untrusted-app`), `values.yaml` (`globalValues` key `approvedRegistry.data.registry`) |
| 030 lab | `~/kyverno-cli-lab/` with `require-run-as-nonroot.yaml` (rule `check-runAsNonRoot`), `good-pod.yaml`, `bad-pod.yaml` and a broken `kyverno-test.yaml` |
| 030 capstone | `~/kyverno-cli-lab/` with `require-run-as-nonroot.yaml`, `disallow-latest-tag.yaml` (rules `require-image-tag`, `validate-image-tag`), `good-pod.yaml`, `bad-nonroot-pod.yaml`, `bad-image-pod.yaml`, `bad-both-pod.yaml`; no test manifest |
| 040 lab | `~/jp-lab/pod.json` (Pod `checkout-web-7f8c9`, namespace `"  checkout  "` with spaces, labels `team: checkout`, `environment: PRODUCTION`, containers `web` and `sidecar`) and an empty `~/jp-lab/answers/` |
| 040 capstone | `~/jp-capstone/context.json` (`pod`, `requiredSelector`, `minVersion: 2.0.0`; image `registry.example.com/payments/api:2.3.1`, owner `platform-team@example.com`) and an empty `~/jp-capstone/answers/` |

Course pages may reuse these files as examples, so the reader meets the same
names in the reading and in the mission.

### Environment facts the text must respect

- **Every lab is a `kind` cluster** started by `astrona run`. The bootstrap
  installs the controller with `kubectl create -f .../install.yaml` and waits
  for the four Deployments `kyverno-admission-controller`,
  `kyverno-background-controller`, `kyverno-cleanup-controller` and
  `kyverno-reports-controller`.
- **The CLI is installed by the lab from section 020 on**, into
  `/usr/local/bin/kyverno`. In section 010 the reader installs it.
- **No playgrounds.** Course pages have no `<!-- astrona:playground -->` and
  no `<!-- astrona:playground:renew -->` markers. "Try it" steps run on the
  reader's own machine (most CLI commands need no cluster at all) or in the
  lab terminal. A `## Your mission` section therefore has no
  `astrona stop` / `astrona start` steps: it is run, submit, destroy.
- **CLI 1.13.2 facts checked on the real binary** (October 2026):
  - `kyverno version` prints `Version: 1.13.2`, `Time: ...` and
    `Git commit ID: ...`, with no `v` in front of the number and no Go
    version line.
  - `kyverno test` in 1.13.2 has no `--require-tests`, `-o/--output-format`
    or `--warnings-as-errors`; newer CLIs (checked on 1.19.1) have them.
  - `kyverno jp query` prints the expression as a comment line
    (`# metadata.name`) before the result, on standard output, so a
    redirected answer file holds two lines.
  - `trim` takes two arguments, `trim(string, characters)`;
    `trim(metadata.namespace)` fails with `incorrect number of args`.
  - `semver_compare(version, range)` returns a boolean; a bare second
    argument such as `2.0.0` means "exactly 2.0.0".
  - `kyverno apply` without `--table` lists only the failing resources;
    passing resources appear only in the summary line.
  - `kyverno jp function` lists 49 functions; hashing is `sha256` only.
- **Known lab problems to fix (do not paper over them in the text):** with
  CLI 1.13.2 the graders of the 010 lab and capstone grep for `v1.13.2`,
  the 020 lab grader needs `compliant-app` in the offline output, both 030
  graders run `--require-tests`, and the 040 graders compare answer files
  without allowing for the `# expression` line. Each of these makes a
  correct solution fail grading until the `validation/` script or the
  pinned version is fixed and checked with `astrona test`.

### Where things are in this repo

| What | Where |
| --- | --- |
| Course outline the platform reads: every reading page and lab, in order. Never list `solution.md` here | `astrona.yaml` |
| Overview, curriculum table, how to run things | `README.md` |
| Section overview and its module | `sections/section-0N0/README.md` |
| Module reading: landing page, deep-dive parts, wrap-up | `sections/section-0N0/module-01/course.md`, `course-0N-*.md` |
| Section knowledge check (scenario quiz) | `sections/section-0N0/quiz.md` |
| Final exam simulator for the whole domain | `sections/final-domain-quiz.md` |
| Graded lab: task, walkthrough, setup, grader | `sections/section-0N0/module-01/labs/lab-01/` (`question.md`, `solution.md`, `bootstrap/`, `validation/`) |
| One graded integration lab per section | `sections/section-0N0/capstone/labs/lab-01/` |

A lab folder holds:

| Path | Purpose |
| --- | --- |
| `config.yaml` | Lab definition; `metadata.docs` has `question: "question.md"` and `solution: "solution.md"` |
| `README.md` | Short intro with the run command |
| `question.md` | The exam-style task. Starts with `# Question` and `Solve this question on: \`terminal\`` |
| `solution.md` | Step-by-step walkthrough with real output |
| `bootstrap/01-install-kyverno.sh` | Installs the Kyverno controller v1.13.2 |
| `bootstrap/02-install-kyverno-cli.sh` | Installs the CLI v1.13.2 (sections 020 to 040) |
| `bootstrap/03-*.sh` | Writes the lab's files and Pods, never the graded answer |
| `validation/validate-completed.sh` | The grader: checks files, the live cluster and real CLI runs |

There is no `solution/apply.sh` in this repository yet, so `astrona test`
has no reference end state to apply.

### Lab metadata in `astrona.yaml`

`astrona.yaml` has one entry per section under `modules:` (`module-010` to
`module-040`, then `module-050` for the final quiz). Each section's
`content` lists, in order: the section `README.md`, then for each module its
landing page, its parts, and right after the part a lab tests, a `Question`
reading (`labs/lab-0N/question.md`) followed by the `type: lab` entry; the
module's wrap-up page comes last. The section quiz comes next, and the
section capstone closes the section.

Every `type: lab` entry (module labs and capstones) carries these fields, in
this order:

```yaml
      - type: reading
        title: Question
        path: sections/section-010/module-01/labs/lab-01/question.md
      - type: lab
        title: "Kyverno CLI Installation Lab"
        path: sections/section-010/module-01/labs/lab-01
        difficulty: beginner
        estimated_duration: 15m
        topic: installation
        task_kind: build
        tags: [release-tarball, path, kyverno-version, version-pinning]
        learning_goals:
          - Install a pinned Kyverno CLI release from its GitHub tarball
          - Prove with kyverno version which binary the shell runs
        resources:
          - name: "Kyverno CLI"
            url: https://kyverno.io/docs/subprojects/kyverno-cli/
```

- `difficulty`: `beginner`, `intermediate` or `advanced`.
- `estimated_duration`: realistic time to solve it, for example `15m`, `30m`, `45m`.
- `topic`: exactly one of `installation`, `apply`, `testing`, `jmespath`.
- `task_kind`: exactly one of `build` (do the task or write the file from
  scratch), `troubleshooting` (find and fix what is broken) or `migration`
  (move a working setup to another form, for example a values file to a
  live `ConfigMap`). The platform filters labs by it, so it is a field of its
  own, never a tag.
- `tags`: 4 to 8 ids, only from the tag list below. Add a new tag to the list
  first if nothing fits.
- `learning_goals`: 2 or 3 plain sentences, each starting with a verb, saying
  what the learner proves in this lab.
- `resources`: 1 to 4 documentation pages, each with a `name` and a `url`
  that loads. This is the **only** place outside links are allowed: the
  platform shows them as optional further reading next to the lab.

**Tag list** (lower case, hyphens, never synonyms):

- Installing: `release-tarball`, `homebrew`, `krew`, `kubectl-plugin`,
  `path`, `checksum`, `version-pinning`, `kyverno-version`,
  `shell-completion`
- Policies: `clusterpolicy`, `validate-rule`, `pattern`, `enforce`,
  `admission`, `autogen`
- Apply: `kyverno-apply`, `offline-apply`, `cluster-apply`, `values-file`,
  `set-variables`, `context-variables`, `configmap-context`,
  `policy-report`, `namespace-scope`, `exit-codes`
- Test: `kyverno-test`, `test-manifest`, `test-results`,
  `resource-grouping`, `require-tests`, `test-case-selector`, `ci-gate`
- JMESPath: `kyverno-jp`, `jp-query`, `jp-function`, `jmespath-syntax`,
  `projections`, `filters`, `literals`, `string-functions`, `pattern-match`,
  `regex-match`, `semver-compare`, `label-match`
- Tools: `kubectl`, `cli-help`

### Running things

```bash
# Lab or capstone (graded against the live cluster)
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-010/module-01/labs/lab-01
astrona submit -c sections/section-010/module-01/labs/lab-01
astrona destroy ats-009-lab-001   # takes metadata.name from config.yaml, not the path

# Authors: run a local, uncommitted copy, and check a lab
astrona run -c sections/section-010/module-01/labs/lab-01
astrona validate -c sections/section-010/module-01/labs/lab-01
```

Lab names (from `config.yaml` `metadata.name`), numbered in course order:

| Lab | Name |
| --- | --- |
| `sections/section-010/module-01/labs/lab-01` | `ats-009-lab-001` |
| `sections/section-010/capstone/labs/lab-01` | `ats-009-lab-002` |
| `sections/section-020/module-01/labs/lab-01` | `ats-009-lab-003` |
| `sections/section-020/capstone/labs/lab-01` | `ats-009-lab-004` |
| `sections/section-030/module-01/labs/lab-01` | `ats-009-lab-005` |
| `sections/section-030/capstone/labs/lab-01` | `ats-009-lab-006` |
| `sections/section-040/module-01/labs/lab-01` | `ats-009-lab-007` |
| `sections/section-040/capstone/labs/lab-01` | `ats-009-lab-008` |

Keep those names. A new lab takes the next free number (`ats-009-lab-009`),
so two labs never share a name. Lab bootstrap scripts do not pin a kube
context: astrona sets `KUBECONFIG` for the lab. Every lab must pass
`astrona validate` and `astrona test`.

Graders check **results**, not just that a file exists: they re-run
`kyverno test`, re-run `kyverno jp query`, compare checksums and try the
live admission. A lab's `question.md` and `solution.md` must match what its
`validation/` scripts actually check.

Test clusters on the maintainer's machine: one at a time. Podman also runs
the platform stack; parallel clusters run it out of memory.

### Where to find trusted sources

Check facts here before writing them down. Prefer these over memory, and
prefer the installed 1.13.2 binary over both.

- **The CLI (install, apply, test, jp):**
  <https://kyverno.io/docs/subprojects/kyverno-cli/>
- **Command reference, one page per command:**
  [kyverno apply](https://kyverno.io/docs/kyverno-cli/reference/kyverno_apply/),
  [kyverno test](https://kyverno.io/docs/kyverno-cli/reference/kyverno_test/),
  [kyverno jp query](https://kyverno.io/docs/kyverno-cli/reference/kyverno_jp_query/),
  [kyverno jp function](https://kyverno.io/docs/kyverno-cli/reference/kyverno_jp_function/),
  [kyverno version](https://kyverno.io/docs/kyverno-cli/reference/kyverno_version/),
  [kyverno completion](https://kyverno.io/docs/kyverno-cli/reference/kyverno_completion/)
- **Guides:** [testing policies](https://kyverno.io/docs/guides/testing-policies/),
  [applying policies](https://kyverno.io/docs/guides/applying-policies/),
  [reports](https://kyverno.io/docs/guides/reports/)
- **Policy language used by the examples:**
  [validate rules](https://kyverno.io/docs/policy-types/cluster-policy/validate/),
  [variables](https://kyverno.io/docs/policy-types/cluster-policy/variables/),
  [JMESPath in Kyverno](https://kyverno.io/docs/policy-types/cluster-policy/jmespath/),
  [external data sources](https://kyverno.io/docs/policy-types/cluster-policy/external-data-sources/),
  [autogen](https://kyverno.io/docs/policy-types/cluster-policy/autogen/)
- **JMESPath itself:** <https://jmespath.org/specification.html>
- **Releases and asset names:** <https://github.com/kyverno/kyverno/releases>
- **The exam itself:** the KCA page on the Linux Foundation training site,
  <https://training.linuxfoundation.org/certification/kyverno-certified-associate-kca/>,
  lists the domains and weights (Kyverno CLI 12%: apply, test, jp,
  installing Kyverno CLI).

### Skills to use here

The `astrona-course-*` skills do most authoring jobs in this repository: planning
(`domain-plan`), creating the tree (`domain-scaffold`), building modules
(`domain-build`), deep-dive parts (`deep-dive`), labs and playgrounds (`lab`),
lab docs (`lab-docs`), challenges (`create-challenge`), quizzes
(`generate-assessment`) and fact-checking (`review-accuracy`).
