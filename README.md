# CloudPath — Self-Service Deployment Platform

An 8-week individual DevOps engineering project: taking a small Spring Boot application from code to a monitored, running service — using Docker, GitHub Actions, Kubernetes, and Terraform.

## What this project demonstrates

A complete, automated path from writing code to running it live:
Push code → CI checks → Build Docker image → Deploy to Kubernetes → Monitor and recover

## Architecture

```
Developer --> GitHub --> GitHub Actions (test, build, scan)
                              |
                              v
                        Docker image --> Kubernetes --> Monitoring
```

## Tech stack

- **Language:** Java 21, Spring Boot 4.1
- **Build tool:** Maven
- **Containerization:** Docker
- **CI/CD:** GitHub Actions
- **Orchestration:** Kubernetes (kind)
- **Infrastructure as Code:** Terraform (Docker provider, local resources)
- **Security scanning:** Trivy

## Application endpoints

| Endpoint | Purpose |
|---|---|
| `GET /tasks` | Returns a sample task list |
| `GET /actuator/health` | Health check used by Kubernetes/monitoring |
| `GET /info` | Returns a configurable message (set via `APP_MESSAGE` env var) |

## Running locally

```bash
./mvnw spring-boot:run
```

App runs on `http://localhost:8080`.

## Running with Docker

```bash
./mvnw clean package -DskipTests
docker build -t cloudpath-app .
docker run --name cloudpath-app-container -p 8080:8080 cloudpath-app
```

The container runs as a non-root user (`appuser`) for security.

## CI/CD

Every push to `main` automatically triggers a GitHub Actions pipeline that runs the tests, builds the jar, builds the Docker image, and runs a Trivy security scan. Workflow file: `.github/workflows/ci.yml`.

## Running on Kubernetes (local, via kind)

```bash
kind create cluster --name cloudpath-cluster
kind load docker-image cloudpath-app --name cloudpath-cluster

kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

kubectl port-forward -n cloudpath svc/cloudpath-service 8080:8080
```

App is then reachable at `http://localhost:8080`, same as running locally or via Docker.

Kubernetes objects used:
- **Namespace** (`cloudpath`) — groups all project resources
- **ConfigMap** — supplies `APP_MESSAGE` as an environment variable
- **Secret** — demonstrates safe handling of sensitive values (demo value only, no real secrets)
- **Deployment** — runs the container as a pod, restarts it automatically if it fails
- **Service** (NodePort) — exposes the app so it can be reached from outside the cluster

## Infrastructure as Code (Terraform)

Terraform is used with the Docker provider to manage local resources — no AWS or paid cloud resources are used, to stay within free-tier cost limits.

```bash
cd terraform
terraform init
terraform fmt
terraform validate
terraform plan
```

Plan output is saved as evidence at `docs/terraform-plan-week5.txt`.

## Release rollout and rollback

Demonstrated by updating the `APP_MESSAGE` ConfigMap value, rolling it out, and testing rollback:

```bash
kubectl apply -f k8s/configmap.yaml
kubectl rollout restart deployment/cloudpath-deployment -n cloudpath
kubectl rollout status deployment/cloudpath-deployment -n cloudpath
```

**Finding:** `kubectl rollout undo` only reverts settings defined directly on the Deployment (image, replicas, inline env vars) — it does **not** revert a separately managed ConfigMap's content. Recovering a ConfigMap change requires manually reapplying a prior version (e.g. from Git history). Full write-up: `docs/week6-rollout-rollback-notes.md`.

## Project status

- [x] Week 1 — Application built (endpoints, health check, env-based config, test)
- [x] Week 2 — Dockerized (Dockerfile, .dockerignore, non-root user, Trivy scan)
- [x] Week 3 — CI pipeline (GitHub Actions: test, build, Docker, Trivy scan on every push)
- [x] Week 4 — Kubernetes deployment (namespace, configmap, secret, deployment, service — verified on local kind cluster)
- [x] Week 5 — Terraform infrastructure (Docker provider, init/fmt/validate/plan evidence)
- [x] Week 6 — Release rollout/rollback testing (with documented ConfigMap rollback finding)
- [ ] Week 7 — Monitoring and documentation
- [ ] Week 8 — Final demo and submission

## Author

Dakshina — CCA DevOps Engineer Internship (Codezela)