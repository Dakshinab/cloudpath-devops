# Week 6 — Release Rollout and Rollback

## What was changed
Updated the `APP_MESSAGE` value in the ConfigMap from
"Hello from Kubernetes ConfigMap!" to
"Hello from Kubernetes ConfigMap - Version 2!" to simulate an app update.

## Rollout
- Applied the updated ConfigMap: `kubectl apply -f k8s/configmap.yaml`
- Restarted the deployment to pick up the new value: `kubectl rollout restart deployment/cloudpath-deployment -n cloudpath`
- Confirmed success: `kubectl rollout status` returned "successfully rolled out"
- Verified via `curl http://localhost:8080/info` — returned the Version 2 message, confirming the update was live

## Rollback attempt and finding
Ran `kubectl rollout undo deployment/cloudpath-deployment -n cloudpath` to roll back.
Rollout reported success, but `curl /info` still returned the Version 2 message.

**Root cause:** `kubectl rollout undo` reverts the Deployment's own history
(image, replicas, env vars defined directly on the Deployment) — it does
NOT revert the content of a separately-managed ConfigMap. Since our
`APP_MESSAGE` lives in a ConfigMap, not directly on the Deployment,
the rollback had nothing to revert on that front.

## Fix applied
Manually edited `k8s/configmap.yaml` back to the original message,
reapplied it, and restarted the deployment again. Verified via `curl`
that the original message was restored.

## Takeaway
For real rollback safety on ConfigMap/Secret changes, either:
- keep every ConfigMap change committed to Git, and restore a prior
  version with `git checkout <commit> -- k8s/configmap.yaml` before
  reapplying, or
- version ConfigMap names (e.g. `cloudpath-config-v1`, `-v2`) and
  switch which one the Deployment references.

`kubectl rollout undo` alone is only reliable for changes that live
directly on the Deployment object itself.
