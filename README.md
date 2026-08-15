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
- **CI/CD:** GitHub Actions (in progress)
- **Orchestration:** Kubernetes (kind, planned)
- **Infrastructure as Code:** Terraform (planned)
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

## Project status

- [x] Week 1 — Application built (endpoints, health check, env-based config, test)
- [x] Week 2 — Dockerized (Dockerfile, .dockerignore, non-root user, Trivy scan)
- [ ] Week 3 — CI pipeline (GitHub Actions)
- [ ] Week 4 — Kubernetes deployment
- [ ] Week 5 — Terraform infrastructure
- [ ] Week 6 — Release rollout/rollback testing
- [ ] Week 7 — Monitoring and documentation
- [ ] Week 8 — Final demo and submission

## Author

Dakshina — DevOps Engineer Internship (Codezela)
