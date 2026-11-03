# Question

Solve this question on: `terminal`

Astronaut, your mission: build a small, orderly test suite for a fleet. Your working folder is `~/kyverno-cli-lab`. It already holds:

*   `policies/restrict-registry.yaml`: a `ClusterPolicy` with the rule `check-registry`. It needs the variable `registryConfig.data.prefix`.
*   `policies/platform-admin-only.yaml`: a `ClusterPolicy` with the rule `block-platform-tier`. It turns away Pods labelled `tier: platform` unless the requester has the cluster role `cluster-admin`.
*   `policies/legacy-exception.yaml`: a `PolicyException` that frees `legacy-pod` from `check-registry`.
*   `resources/`: the Pods `good-registry-pod` (approved image), `bad-registry-pod` and `legacy-pod` (both with an image from `docker.io`), and `platform-pod` (labelled `tier: platform`).
*   `values/registry-values.yaml`: gives `registryConfig.data.prefix` the value `registry.example.com`.
*   `userinfo/admin.yaml` (cluster role `cluster-admin`) and `userinfo/dev.yaml` (cluster role `edit`).

There are no test manifests yet. Use the provided inputs. Do not edit them.

1.  Create the folder `tests/registry` with a `kyverno-test.yaml`. It uses the values file and the exception. It claims `pass` for `good-registry-pod`, `fail` for `bad-registry-pod` and `skip` for `legacy-pod`.
2.  Create `tests/platform-admin/kyverno-test.yaml`. It uses `userinfo/admin.yaml` and claims `skip` for `platform-pod`.
3.  Create `tests/platform-dev/kyverno-test.yaml`. It uses `userinfo/dev.yaml` and claims `fail` for `platform-pod`.
4.  From `~/kyverno-cli-lab`, run `kyverno test .` and confirm it exits `0` with five cases reported.

The grader runs six checks in `~/kyverno-cli-lab`:

*   At least three files named `kyverno-test.yaml` exist under `tests/`, and together they use `variables`, `userinfo` and `exceptions`.
*   `kyverno test .` exits `0` and at least five tests passed.
*   The suite really uses the values file: with another approved registry in a scratch copy, it must fail.
*   The suite really uses the admin badge: if `admin.yaml` loses `cluster-admin` in a scratch copy, it must fail.
*   The suite really tests the exception: if the exception covers another Pod in a scratch copy, it must fail.
*   The suite really claims `fail` for `bad-registry-pod`: if that Pod is repaired in a scratch copy, it must fail.
