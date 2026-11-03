# Solution Walkthrough

Five small steps, one helper button each. After each step you can run `astrona submit` and read the feedback: the checks for the steps you finished pass, the others fail with a hint.

All commands run in the lab terminal, where you are the administrator, so no `sudo` is needed. Start in the lab folder:

```sh
cd /root/toolbox-lab
```

---

## Step 1: Print the command reference

The `docs` command writes one markdown file per command. Its own examples set the experimental switch, so set it in front of the command. The command creates the folder:

```sh
KYVERNO_EXPERIMENTAL=true kyverno docs -o /root/toolbox-lab/reference --autogenTag=false
ls /root/toolbox-lab/reference
```

The list holds files named `kyverno_<command>.md`, among them `kyverno_apply.md` and `kyverno_test.md`.

---

## Step 2: Write the zsh completion script

`kyverno completion zsh` prints the script. Send it to the file named in the task:

```sh
kyverno completion zsh > /root/toolbox-lab/_kyverno
head -1 /root/toolbox-lab/_kyverno
```

The first line is `#compdef kyverno`. That line tells zsh which command the script completes.

---

## Step 3: Give the binary the plugin name

`kubectl` turns any executable named `kubectl-<name>` on the `PATH` into a plugin. A link named `kubectl-kyverno` that points at the `kyverno` binary does it:

```sh
ln -s /usr/local/bin/kyverno /usr/local/bin/kubectl-kyverno
kubectl kyverno version
```

The second command prints `Version: 1.13.2`, the build time and the Git commit, the same as `kyverno version`. If it says `unknown command`, run `kubectl plugin list` and check that the link is listed.

---

## Step 4: Scaffold the test file

Each `--pass` or `--fail` value is policy, rule, resource, namespace and kind. Give both Pod files with two `-r` flags, and write the file with `-o`:

```sh
kyverno create test -p policy.yaml -r compliant-app.yaml -r legacy-app.yaml \
  --pass require-team-label,check-team-label,compliant-app,apps,Pod \
  --fail require-team-label,check-team-label,legacy-app,apps,Pod \
  -o scaffold-test.yaml
cat scaffold-test.yaml
```

The file lists `policy.yaml` under `policies` and both Pod files under `resources`. Its `results` list has two entries: `compliant-app` with `result: pass` and `legacy-app` with `result: fail`.

---

## Step 5: Scaffold the user-info file

Give the user name with `-u`, the group with `-g`, the cluster role with `-c`, and the file with `-o`:

```sh
kyverno create user-info -u alice@example.com -g developers -c admin -o user-info.yaml
cat user-info.yaml
```

The file shows `admin` under `clusterRoles`, and the user name `alice@example.com` and the group `developers` under `userInfo`.

---

## Submit

Send the mission for grading:

```sh
astrona submit -c sections/section-010/module-02/labs/lab-01
```

All five checks should pass. If one fails, its hint names the flag or the file to look at.
