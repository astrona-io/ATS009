# Solution Walkthrough

Four steps: preview the mutation, preview the generation, hand the scanner a badge, then send the repaired ship to the cluster.

---

## Step 1: Mutate with `-o`

Move into the lab folder and run the mutate policy on the Pod. `-o` writes the patched Pod to a file:

```sh
cd /root/mutate-lab
kyverno apply mutate-policy.yaml --resource scout.yaml -o scout-mutated.yaml
```

The CLI also prints the patched Pod on screen. Check the file:

```sh
grep tier scout-mutated.yaml
grep -c tier scout.yaml
```

The first command prints the line `tier: standard` and the second prints `0`. The new file has the label, and the original blueprint was never touched: `apply` only reads `scout.yaml`.

---

## Step 2: Generate with `-o`

The trigger is the `Namespace` in `venus.yaml`. The rule builds a `ConfigMap` for it:

```sh
kyverno apply generate-policy.yaml --resource venus.yaml -o welcome-generated.yaml
cat welcome-generated.yaml
```

The file holds a `ConfigMap` named `welcome` in the namespace `venus`, with the data `message: welcome-aboard`. The rule took the namespace name from `{{request.object.metadata.name}}`, which is the `Namespace` you gave with `--resource`. Nothing was created in the cluster.

---

## Step 3: Write the user info file

First see the failure:

```sh
kyverno apply bridge-policy.yaml --resource scout.yaml
echo $?
```

The summary line reports one fail and `echo` prints `1`. The policy denies everyone except the cluster role `bridge-officer`, and offline the CLI does not know who is asking. Save this as `bridge-officer.yaml`:

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: UserInfo
clusterRoles:
  - bridge-officer
```

Run it again with `-u`:

```sh
kyverno apply bridge-policy.yaml --resource scout.yaml -u bridge-officer.yaml
echo $?
```

The rule's `exclude` block now matches the role in the file, so `scout` is waved through, and `echo` prints `0`.

---

## Step 4: Create the repaired Pod

Apply the file from step 1, not the original:

```sh
kubectl apply -f scout-mutated.yaml
kubectl -n apps get pod scout --show-labels
```

The `LABELS` column shows `app=scout,tier=standard`. The cluster has no Kyverno controller, so the label is there only because you applied the file the CLI wrote.

---

## Submit

Send the mission for grading. The grader runs four checks. If one fails, its hint tells you what to fix. Run the step again and submit again:

```sh
astrona submit -c sections/section-020/module-02/labs/lab-01
```
