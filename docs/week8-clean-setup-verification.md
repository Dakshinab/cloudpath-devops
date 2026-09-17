# Week 8 — Clean Setup Verification

## Test performed
Deleted the existing kind cluster entirely and recreated the full
environment following only the steps documented in README.md, with
no additional undocumented steps.

## Steps followed (from README)
1. kind create cluster --name cloudpath-cluster
2. kind load docker-image cloudpath-app --name cloudpath-cluster
3. kubectl apply -f k8s/namespace.yaml
4. kubectl apply -f k8s/configmap.yaml
5. kubectl apply -f k8s/secret.yaml
6. kubectl apply -f k8s/deployment.yaml
7. kubectl apply -f k8s/service.yaml
8. kubectl port-forward -n cloudpath svc/cloudpath-service 8080:8080

## Result
All resources created successfully with no errors. Application
verified working:
- GET /tasks returned the expected task list
- GET /actuator/health returned {"status":"UP"}

## Conclusion
README setup instructions are complete and accurate — a fresh
environment can be brought up from scratch using only the
documented steps.
