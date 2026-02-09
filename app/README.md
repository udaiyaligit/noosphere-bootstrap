Node.js Express API template for the DevOps tech test.

Quick start

# Build image
npm install

# Run locally
npm start

# Or build with Docker
docker build -t localstack/my-api:latest .

docker-compose up -d

Endpoints

GET /health  - returns health (includes database check placeholder)
GET /api/data - returns sample JSON

Logging

Kubernetes (Required — intentionally broken)

The `k8s/` manifests are required for this assessment and have an intentional bug to test troubleshooting skills. The Deployment selector and pod template labels have been made inconsistent so the manifest will fail validation or create no pods. Fix the manifests before running them.

If you prefer to run the API in Kubernetes, the repository contains `k8s/` manifests (namespace, deployment, service). Build and tag the image as `localstack/my-api:latest` or update `k8s/deployment.yaml` to point to your image.

To test locally with port-forwarding:

```bash
# from repo root after applying manifests
kubectl -n devops-tech-test port-forward svc/api-service 8080:80
curl http://localhost:8080/health
```

Logging

Requests and app logs use structured JSON with `x-trace-id` propagated.
