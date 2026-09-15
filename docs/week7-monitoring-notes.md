# Week 7 — Monitoring Evidence

## Pod health and resource usage
See `week7-monitoring-evidence.txt` — pod status (Running, 0 restarts),
and resource usage (2m CPU, 153Mi memory) captured via `kubectl top pods`.

## Application logs
See `week7-app-logs.txt` — clean startup, no errors, Tomcat serving on
port 8080 as expected.

## Health endpoint check
`/actuator/health` returns `{"status":"UP"}` — this is the primary
signal used by Kubernetes itself to know the pod is healthy, and would
be the first thing checked manually if the app seemed unresponsive.

## Simple failure/alert approach
No dedicated alerting tool (Prometheus/Alertmanager) is set up for this
project — for a project at this scale, failure detection relies on:
- `kubectl get pods` — a pod not in `Running` state, or with climbing
  RESTARTS count, is the first visible sign of a problem
- `kubectl logs <pod>` — checked immediately after spotting a bad
  status, to read the actual error
- `/actuator/health` returning anything other than `UP` — the
  application-level equivalent of the same signal

## Common failure signs to watch for
- Pod stuck in `CrashLoopBackOff` — usually a startup error (bad
  config, missing dependency) — checked via `kubectl logs`
- Pod `Pending` — usually a resource or scheduling issue — checked
  via `kubectl describe pod <pod-name>`
- Health endpoint returning `DOWN` — application is running but an
  internal check (e.g. a dependency) is failing
