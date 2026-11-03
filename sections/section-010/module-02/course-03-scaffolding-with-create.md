# Scaffolding Files with `kyverno create`

Astronaut, nobody likes a blank page. The `kyverno create` command prints a starter file for you, with the right shape and the right field names, and you only fill in the details. This part shows the helpers you need most, and names the others.

## One command, several helpers

`kyverno create` has one sub-command for each kind of file. Each one prints the file to the screen. Add `-o <path>` to write it to a file instead. This is the same idea as a printed form: the scanner gives you the form, and you decide what to write on it.

| Sub-command | What it writes | Where the file is used |
| --- | --- | --- |
| `test` | A test file: policies, resources and the expected result for each | `kyverno test` |
| `values` | A values file: answers the policy would otherwise ask the cluster for | `kyverno apply` and `kyverno test` |
| `user-info` | A user-info file: who is making the request, with groups and roles | `kyverno apply` and `kyverno test` |
| `exception` | A `PolicyException`: a rule that lets chosen resources skip chosen rules | A cluster |
| `metrics-config` | A `ConfigMap` that says which namespaces appear in the metrics | A cluster |

Newer CLIs add `kyverno create cluster-role`. The 1.13.2 binary does not have it, so check `kyverno create --help` on your own binary.

## Scaffold a test file

The most useful helper is `create test`. You name the policy, the resources and the results you expect. The scanner writes the lines for you.

### Write the file

<!-- astrona:playground:renew -->

Run it in the scratch folder. Each `--pass` or `--fail` value lists five things in order: policy name, rule name, resource name, namespace and kind:

```sh
cd /root/toolbox
kyverno create test -p policy.yaml -r compliant-app.yaml -r legacy-app.yaml \
  --pass require-team-label,check-team-label,compliant-app,apps,Pod \
  --fail require-team-label,check-team-label,legacy-app,apps,Pod \
  -o scaffold-test.yaml
```

The command prints nothing, because `-o` sends the file to disk. Read it:

```sh
cat scaffold-test.yaml
```

The file has a `name` line, a `policies` list with `policy.yaml`, a `resources` list with both Pod files, an empty `variables` line, and a `results` list. The `results` list has two entries: `compliant-app` expects `result: pass`, and `legacy-app` expects `result: fail`. Comment lines above each block say what it is for.

The scaffold is a starting point. Read it and check the names before you rely on it.

## Scaffold values and user-info files

Some policies ask questions that only a cluster can answer, such as who sent the request. The CLI works offline, so you hand it the answers in a file. This is a prepared answer sheet.

### Write the files

A user-info file says who makes the request. Give a user name, a group and a cluster role:

```sh
kyverno create user-info -u alice@example.com -g developers -c admin -o user-info.yaml
cat user-info.yaml
```

The file has a `roles` list, a `clusterRoles` list holding `admin`, and a `userInfo` block with the `username` `alice@example.com` and the group `developers`.

A values file holds global values. The flag `-g` takes one `name=value` pair:

```sh
kyverno create values -g request.mode=dev -o values.yaml
cat values.yaml
```

The file lists `request.mode: dev` under `globalValues`, next to empty `policies` and `namespaceSelector` lists that you can fill in later.

## The cluster-side helpers

Two helpers write objects that belong in a cluster, so they print complete Kubernetes YAML. Without `-o`, they print to the screen, and nothing is applied anywhere.

### Preview them

Print an exception for the `legacy-` Pods, and a metrics configuration that includes the `apps` planet and leaves out `kube-system`:

```sh
kyverno create exception allow-legacy --namespace apps --policy-rules "require-team-label,check-team-label" --any "kind=Pod,name=legacy-*"
kyverno create metrics-config -i apps -e kube-system
```

The first prints a `PolicyException` named `allow-legacy` in the namespace `apps`. It lists the policy `require-team-label` and the rule `check-team-label`, and it matches Pods whose name starts with `legacy-`. The second prints a `ConfigMap` named `kyverno-metrics` in the namespace `kyverno`, with the included and excluded namespaces in its data.

> [!TIP]
> Run any `create` helper without `-o` first. You see the result on screen, and you write the file only when you like it.

## Common pitfalls

> [!WARNING]
> - **Forgetting `-o`.** Without it the file goes to the screen, and you have nothing on disk.
> - **Getting the order of `--pass` wrong.** The five values are policy, rule, resource, namespace and kind, in that order. Mixed-up values give a result line that matches nothing.
> - **Mistaking `exception` output for an applied exception.** The command only prints YAML. The exception counts only after someone applies it to a cluster.
> - **Treating a scaffold as finished.** It is a form with the lines drawn. You still check that the names are right and that the file does what you expect.

## Your mission: The Kyverno CLI Toolbox Lab

You can now print the manual, write completion scripts, give the binary a plugin name and scaffold files with `kyverno create`. The mission puts a machine in front of you where the CLI is installed and asks you to use each helper once: the command reference, a zsh completion script, the `kubectl kyverno` plugin name, a test scaffold and a user-info file.

Pause the playground first, so the lab has the memory it needs:

```sh
astrona stop ats-009-playground-010-02
```

Start the mission, read the task in [`question.md`](./labs/lab-01/question.md) and solve it on your own first. When you think you are done, send it for grading:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-010/module-02/labs/lab-01
astrona submit -c sections/section-010/module-02/labs/lab-01
```

When the mission is done, remove it and start the playground again:

```sh
astrona destroy ats-009-lab-009
astrona start ats-009-playground-010-02
```
