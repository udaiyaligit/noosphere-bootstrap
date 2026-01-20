# DevOps/Platform Engineer - Technical Assessment

**Role level:** Mid-Level Platform Engineer

## Overview

Welcome! On your first day you inherit a work in progress branch for a small microservices API. The application is a Node.js/Express service exposing `/health` and `/api/data`. The Dockerfile was apparently working locally, the CI/CD pipeline is partially built but incomplete, and Terraform has quite a few issues. What you'll need to do is use git to understand the current state of the repo, compare what is currently true and follow the ticket (task below) to determine next steps and what is missing.
Your goal is the following:

- Working CI/CD using github workflow for github actions,
- Dockerfile builds locally or within the workflow.
- Terraform is built to the spec under part 1 and plans and builds successfully.
- Docker image built can deploy using a k8s manifest.
- Ensure use of git throughout using conventional commits where possible, atomic commits are your friend.

High-level mission:

- Fix infrastructure (Terraform) and CI/CD so they work
- Remove hardcoded secrets and implement secure secrets management
- Harden the application and ensure least-privilege permissions
- Optionally implement one extension (Observability, Platform resilience, Developer experience)

## Tooling

Tooling is down to you, provided you use Github Actions for the CI/CD this can done using either Github CI or a tool called ACT to them run locally see: https://github.com/nektos/act
k3s instead of k8s, this should allow you to run a local k8s cluster with minimal effort.
LocalStack instead of AWS this will allow to simulate cloud locally.

## Scaffolding Provided

To help you get started, we've provided partial implementations with TODOs:

- **`.github/workflows/ci.yml`** - Partial CI pipeline with build job structure. Complete the Docker and Grype steps.
- **`terraform/ec2.tf`** - EC2 scaffolding with AMI data source. Implement the instances using `var.instances`.
- **`terraform/vpc.tf`** - VPC exists, subnets need to be added.
- **`terraform/envs/dev.tfvars`** - Environment-specific variables file. Define your instance configurations here.

Run Terraform with: `terraform plan -var-file=envs/dev.tfvars`

---

## Part 1 — Core Implementation (NO LLM Assistance)

Complete the following tasks without using LLM coding assistants. We want to observe your raw troubleshooting and decision-making so no GPT help.

1. Fix the Infrastructure (`/terraform`)
   - Create a VPC with public subnets.
   - Create 3 different EC2s with different configs using repeatable code that could be extended in future.
   - Make S3 bucket and add a lifecycle policy to auto-delete objects after 7 days.

2. Build the CI/CD pipeline (`.github/workflows`)
   - Add build step for the Dockerfile.
   - Add container security scanning with Grype.

3. Application hardening
   - Verify the `Dockerfile` runs the app as a non-root user.
   - Ensure only what the application requires to run is present.

4. Security & permissions
   - Implement least-privilege IAM role to be used for the Github Action pipeline.
   - Ensure no secrets are committed in plaintext in any configuration files.

5. Kubernetes
   - Fix the manifests located in k8s/
   - Must be able to deploy the Docker image built from the Dockerfile

6. Git
   - Ensure use of git for version control, using conventional commits.
   - Add semver tagging to the Github Action workflow and ensure tags are applied correctly.

## Part 2 — Extension (LLM Assistance ALLOWED)

Choose one enhancement and document how you used an LLM (if any) in `LLM_USAGE.md`.

Options (pick one):

- Observability
  - Add Prometheus metrics to the Express app (latency, error rates).
  - Deploy Prometheus + Grafana create a dashboard.
  - Ensure metrics persist through container restarts.

- Platform resilience
  - Ensure the application can scale using HPA.
  - Ensure the application does not go offline during deployments.
  - Ensure ability to rollback to any previous version if required.
  - Ensure branch protection.

- Developer experience template
  - Build a template repo with the following requirements:
    - Dockerfile template following best practices.
    - Github Actions workflows using at least 1 composite action and 1 action built in another repo.
    - Implement Github Action summaries that can be shown mid run with useful information.
    - Implement a step that will comment on a PR with the reason why the build failed, have this update in place for future runs.
    - Implement githook that does commit/lint/test checks before allowing a commit/push.

Documentation requirement: Save your LLM conversations and explain what was incorrect, what you changed, and how you validated suggestions.

## Deliverables

- A working repository that can be cloned and run with minimal setup.
- Proof of functionality (example `curl` commands that show successful endpoints).
- Architecture decision document: `DECISIONS.md` explaining secrets management, security improvements, and trade-offs.
- If Part 2 completed: `LLM_USAGE.md` with conversation logs and analysis.

## What We're Evaluating

- Platform thinking: developer experience, automation, clear abstractions.
- Ops → DevOps mindset: infrastructure as code and security by default.
- Pragmatism: avoid gold-plating while not introducing dangerous shortcuts.
- Security instinct: finding hardcoded secrets and minimizing blast radius.
- Troubleshooting: systematic debugging.
- Adaption: ability to adapt to the situation and confidence to try.

Success looks like: `git push` → GitHub Actions builds successfully.

- Clean commits following conventional commits.
- Git push triggers Github Actions that runs successfully.
- Dockerfile that can be built using CI or local commands.
- Terraform that can be deployed.
- Kubernetes manifests that can be used to deploy.
- Security hardening.

## Getting Started

### Prerequisites

- Docker & Docker Compose
- Terraform >= 1.5
- AWS CLI v2
- Node.js >= 18
- `awslocal` (awscli-local): `pip install awscli-local` if using localstack

### Quick Start

1. Fork the repository

2. Clone the repository

```bash
git clone <your-repo-url>
cd tech-test
```

Quick steps:

1. Build the container image locally (tag matches manifests):

```bash
# from repo root
docker build -t repo/my-api:latest .
```

2. Apply manifests to your cluster:

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

3. Expose the service (port-forward) and test endpoints:

```bash
kubectl -n devops-tech-test port-forward svc/api-service 8080:80
# then in another terminal
curl http://localhost:8080/health
curl http://localhost:8080/api/data
```

Notes:

- The Deployment includes `readinessProbe` and `livenessProbe` against `/health` and a `securityContext` that runs the container as a non-root user.
- The image field in the manifests needs to be populated. Update `k8s/deployment.yaml` with your built image.

## Testing Your Work

```bash
# Example checks via k8s port-forward (adjust if you changed ports)
curl http://localhost:8080/health
curl http://localhost:8080/api/data

# Or run the container directly
docker run -p 3000:3000 repo/my-api:latest
curl http://localhost:3000/health
```

Also verify Terraform resources were created in LocalStack using `awslocal` commands, and confirm no plaintext secrets remain.

## Interview Discussion Topics

Be prepared to discuss:

- Your decisions in Part 1 and reasons for chosen approaches.
- Secrets management strategy.
- Remaining security concerns if any and suggested mitigations.
- LLM collaboration details (if Part 2 used): prompts, what was wrong, how you validated.
- Platform boundaries: which responsibilities belong to the platform team vs. service teams.

Good luck — we're excited to see your approach!
