# Variables And User Info

Astronaut, some rules cannot decide with the ship's papers alone. One rule needs to know the approved shipyard, which the inspector reads from mission control. Another rule needs to know who is asking. In a real cluster, Kyverno finds those facts itself. In an offline test, there is no mission control and no requester, so you hand the facts over in two small files.

You work in `~/kyverno-cli-lab`.

## A rule with a variable

Look at the registry policy and the two Pods it will check:

<!-- astrona:playground:renew -->

```sh
cd ~/kyverno-cli-lab
cat policies/restrict-registry.yaml
cat resources/good-registry-pod.yaml resources/bad-registry-pod.yaml
```

The rule `check-registry` has a `context` entry named `registryConfig`. In a live cluster, Kyverno would read a `ConfigMap` named `registry-config` from the namespace `platform`. The pattern then says that every image must start with `{{ registryConfig.data.prefix }}/`. That is a variable: a placeholder that is filled in during the check.

An offline test cannot read the `ConfigMap`. You fill the placeholder yourself, with a values file.

## The values file

Look at the file in the folder:

```sh
cat values/registry-values.yaml
```

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Values
policies:
  - name: restrict-registry
    rules:
      - name: check-registry
        values:
          registryConfig.data.prefix: registry.example.com
```

It is a prepared answer sheet. For the policy `restrict-registry` and its rule `check-registry`, the variable `registryConfig.data.prefix` has the value `registry.example.com`. The name of the variable is the name of the `context` entry, followed by the path into the data. A variable has to come from a `context` entry, so a policy that uses a made-up name such as `{{ myValue }}` is not valid.

Save this as `registry-test.yaml`. The line `variables` points to the values file:

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: registry-tests
policies:
  - policies/restrict-registry.yaml
resources:
  - resources/good-registry-pod.yaml
  - resources/bad-registry-pod.yaml
variables: values/registry-values.yaml
results:
  - policy: restrict-registry
    rule: check-registry
    resources:
      - good-registry-pod
    kind: Pod
    result: pass
  - policy: restrict-registry
    rule: check-registry
    resources:
      - bad-registry-pod
    kind: Pod
    result: fail
```

Paths in a manifest are relative to the folder of the manifest. Run it with `-f`:

```sh
kyverno test . -f registry-test.yaml
```

Both rows show `Pass` and the exit code is `0`. `good-registry-pod` really clears the rule, and `bad-registry-pod` really fails it. The values file did its job.

### See the value matter

Open `values/registry-values.yaml` and change `registry.example.com` to `docker.io/library`. Run the test again. Both claims now fail, because the approved shipyard changed: the good Pod no longer fits, and the bad one does. This proves the suite reads the file. Change the value back.

### See a missing variable

Remove the line `variables: values/registry-values.yaml` from the manifest and run again. Both rows fail, and the reason mentions an error instead of a plain wrong verdict. The rule could not fill in the placeholder, so it could not decide. Put the line back.

## Per-resource values and global values

The values file in this part gives one value to one rule. Two more shapes exist:

- `globalValues` gives a value to every policy and rule in the run.
- `policies[].resources[].values` gives a value only to one named resource.

Use the narrowest shape that works. A value that is visible everywhere can hide a mistake in one rule.

## Who is asking?

A rule can also depend on the requester. The policy `platform-admin-only` turns away Pods labelled `tier: platform`, unless the requester has the cluster role `cluster-admin`. In a live cluster, the API server fills in who is asking. Offline, you provide a user info file: a crew badge.

```sh
cat policies/platform-admin-only.yaml
cat userinfo/admin.yaml userinfo/dev.yaml
```

`userinfo/admin.yaml` holds the cluster role `cluster-admin` and the user name `alice`. `userinfo/dev.yaml` holds the role `edit` and the user name `bob`. A manifest can use one user info file, so you write one manifest for each badge.

Save this as `admin-test.yaml`:

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: platform-admin-tests
policies:
  - policies/platform-admin-only.yaml
resources:
  - resources/platform-pod.yaml
userinfo: userinfo/admin.yaml
results:
  - policy: platform-admin-only
    rule: block-platform-tier
    resources:
      - platform-pod
    kind: Pod
    result: skip
```

Save this as `dev-test.yaml`. It has another badge and another claim:

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: platform-dev-tests
policies:
  - policies/platform-admin-only.yaml
resources:
  - resources/platform-pod.yaml
userinfo: userinfo/dev.yaml
results:
  - policy: platform-admin-only
    rule: block-platform-tier
    resources:
      - platform-pod
    kind: Pod
    result: fail
```

Run both:

```sh
kyverno test . -f admin-test.yaml
kyverno test . -f dev-test.yaml
```

Both pass, and each exit code is `0`. With the admin badge, the rule waves the Pod through: its `exclude` block names `cluster-admin`, so the rule does not apply, and the result is `skip`. With the developer badge, the rule applies and turns the Pod away: `fail`.

The same Pod gets two different verdicts, and the badge is the only difference. That is the point of the user info file.

## Common pitfalls

> [!WARNING]
> - **Using a variable that has no `context` entry.** A variable must come from a context entry, or the policy is not valid.
> - **Forgetting the `variables` line.** The rule cannot fill in its placeholder and the run reports an error, not a clean fail.
> - **Typing the variable name wrongly in the values file.** The name is the context entry name plus the path into the data, such as `registryConfig.data.prefix`. A different spelling is not used.
> - **Testing only one badge.** A rule that depends on the requester needs at least two tests: one that is let through and one that is turned away.
> - **Hiding a value in `globalValues`.** A global value reaches every rule. Use the narrow shape when only one rule needs it.
