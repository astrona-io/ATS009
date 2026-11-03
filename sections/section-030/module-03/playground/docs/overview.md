# Overview: Variables, User Info, Exceptions And Large Suites (Playground)

This is a playground, not a lab. It gives you a terminal with the `kyverno` CLI and a folder of practice files, and then waits. There is no task, no `astrona submit` and no pass or fail. Write test manifests, break them on purpose, and read what the run tells you.

## What is in the box

- The `kyverno` CLI, version `1.13.2`, in `/usr/local/bin`. No cluster is needed: `kyverno test` works on files.
- The folder `~/kyverno-cli-lab` with these files:

  | File | What it is |
  | --- | --- |
  | `policies/restrict-registry.yaml` | `ClusterPolicy` with rule `check-registry`. It reads the approved registry from a `ConfigMap` context entry named `registryConfig` |
  | `policies/platform-admin-only.yaml` | `ClusterPolicy` with rule `block-platform-tier`. It turns away `tier: platform` Pods unless the requester has the cluster role `cluster-admin` |
  | `policies/legacy-exception.yaml` | A `PolicyException` that frees `legacy-pod` from `check-registry` |
  | `resources/good-registry-pod.yaml` | A Pod with an image from `registry.example.com` |
  | `resources/bad-registry-pod.yaml` | A Pod with an image from `docker.io` |
  | `resources/legacy-pod.yaml` | A Pod named `legacy-pod`, also with an image from `docker.io` |
  | `resources/platform-pod.yaml` | A Pod labelled `tier: platform` |
  | `values/registry-values.yaml` | A values file that gives `registryConfig.data.prefix` the value `registry.example.com` |
  | `userinfo/admin.yaml` | A user info file: user `alice` with the cluster role `cluster-admin` |
  | `userinfo/dev.yaml` | A user info file: user `bob` with the cluster role `edit` |

- There is no `kyverno-test.yaml`. You write them.

## Practice tasks

- Write a manifest for `restrict-registry` with `variables: values/registry-values.yaml`. Run it with `-f`.
- Change the prefix in the values file and see both claims fail. Change it back.
- Remove the `variables` line and read the error.
- Test `platform-pod` twice, once with `userinfo/admin.yaml` and once with `userinfo/dev.yaml`.
- Add the `exceptions` list for `legacy-pod`, claim `skip`, then remove the exception and see the claim break.
- Move your manifests into folders under `tests/` and run `kyverno test .` from the top folder.
- Narrow a run with `--test-case-selector`.
