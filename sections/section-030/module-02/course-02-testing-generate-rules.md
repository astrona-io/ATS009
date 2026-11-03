# Testing Generate Rules

Astronaut, a generate rule is a dock crew. When a new planet appears in the solar system, the crew builds a standard structure on it, such as a fence that blocks all incoming traffic. The planet is the input. The structure is the output. Your test lists the planet and describes the structure the crew must build.

You work in `~/kyverno-cli-lab`.

## Meet the generate policy

Look at the policy and the namespace it reacts to:

<!-- astrona:playground:renew -->

```sh
cd ~/kyverno-cli-lab
cat add-default-deny.yaml
cat team-a-namespace.yaml
```

The rule `create-default-deny` reacts to every new `Namespace`. It builds a `NetworkPolicy` named `default-deny` in that namespace. The policy has an empty `podSelector`, so it covers every Pod, and it lists `Ingress`, so it blocks incoming traffic.

## Write the expected structure

Save this as `default-deny-generated.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: team-a
spec:
  podSelector: {}
  policyTypes:
    - Ingress
```

Note the `namespace: team-a`. The policy takes the namespace from the new planet, so the expected file must carry that name.

## Write the checklist line

Save this as `generate-test.yaml`:

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: generate-tests
policies:
  - add-default-deny.yaml
resources:
  - team-a-namespace.yaml
results:
  - policy: add-default-deny
    rule: create-default-deny
    resources:
      - team-a
    kind: Namespace
    generatedResource: default-deny-generated.yaml
    result: pass
```

The `resources` name and the `kind` belong to the **trigger**, the Namespace `team-a`. The file in `generatedResource` is the **output**, the NetworkPolicy. Do not mix the two up.

Run it:

```sh
kyverno test . -f generate-test.yaml
```

The table has one row with the result `Pass`, and the exit code is `0`.

### Break the structure on purpose

In `default-deny-generated.yaml`, change `Ingress` to `Egress` and run the same command. The row now shows `Fail` with the reason `Resource diff`. The crew built a policy for incoming traffic, and your file claims outgoing traffic. Change it back to `Ingress`.

## Rules that clone

Some generate rules do not write the new resource from a template. They copy an existing one. That is a clone rule: the dock crew copies a ready-made structure from another planet.

`clone-registry-secret.yaml` copies the `Secret` named `regcred` from the namespace `default` into every new namespace. Look at it, and at the source:

```sh
cat clone-registry-secret.yaml
cat regcred-source.yaml
cat team-b-namespace.yaml
```

The offline test has no cluster to read the source from. You hand it the source as a file with `cloneSourceResource`. Save the expected copy as `regcred-generated.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: regcred
  namespace: team-b
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: e30=
```

Save the manifest as `clone-test.yaml`:

```yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: clone-tests
policies:
  - clone-registry-secret.yaml
resources:
  - team-b-namespace.yaml
results:
  - policy: clone-registry-secret
    rule: copy-regcred
    resources:
      - team-b
    kind: Namespace
    cloneSourceResource: regcred-source.yaml
    generatedResource: regcred-generated.yaml
    result: pass
```

Run it:

```sh
kyverno test . -f clone-test.yaml
```

The result is `Pass` and the exit code is `0`. Now change one character in the `data` value of `regcred-generated.yaml` and run again. The test fails with a `Resource diff`, because the copy no longer equals the source. Change it back.

Without `cloneSourceResource`, the CLI has no source to copy from, so it cannot build the expected copy. Always give the source file with a clone rule.

## Your mission: Mutate And Generate Test Lab

You can now check both what a mutate rule changes and what a generate rule builds. The mission starts a folder with the mutate policy, the generate policy and their input resources. You write the expected files and one `kyverno-test.yaml` that proves all three cases: the mutate pass, the mutate skip and the generated resource.

Pause the playground first, so the lab has the memory it needs:

```sh
astrona stop ats-009-playground-030-02
```

Start the mission, read the task in `question.md`, and send it for grading when you are done:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS009.git -c sections/section-030/module-02/labs/lab-01
astrona submit -c sections/section-030/module-02/labs/lab-01
```

When you are done, remove the lab and start the playground again:

```sh
astrona destroy ats-009-lab-012
astrona start ats-009-playground-030-02
```

## Common pitfalls

> [!WARNING]
> - **Naming the generated resource in `resources`.** The `resources` list and `kind` name the trigger, such as the Namespace. The generated resource goes in the `generatedResource` file.
> - **Forgetting the namespace in the expected file.** A generated resource lands in the new namespace. The expected file needs that `metadata.namespace`.
> - **Leaving out `cloneSourceResource` for a clone rule.** The test needs the source as a file because it has no cluster to read it from.
> - **Trusting a `Resource diff` blindly.** The diff says the two resources differ. It does not say which one is right. Read both.
