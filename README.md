# aws-devops-eks-project

![CI](https://github.com/dbharathip05-ctrl/aws-devops-eks-project/actions/workflows/docker-image.yml/badge.svg)

This is my personal DevOps project where I built a complete CI/CD pipeline 
from scratch using AWS, Docker, Kubernetes, Helm, ArgoCD, and Terraform.
The goal was to automate everything — from a developer pushing code, 
all the way to the application running in a Kubernetes cluster on AWS EKS,
without any manual steps in between.

---

## What this project does

When a developer pushes code to the main branch, GitHub Actions automatically
builds a Docker image and pushes it to AWS ECR. Jenkins then updates the image
tag in the Helm chart. ArgoCD detects that change in Git and deploys the new
version to the EKS cluster automatically. Prometheus and Grafana watch the
running pods and alert if something goes wrong.

The whole cycle takes under 5 minutes — from git push to running pods in EKS.

---

## Why I built it this way

I wanted to implement real GitOps — where Git is the single source of truth.
No one runs kubectl apply manually in production. Every change goes through Git,
every deployment is traceable, and ArgoCD self-heals if someone accidentally 
changes something directly in the cluster.

I also focused on security from the start — containers run as non-root users,
secrets never live in code or Git, and every AWS service uses IAM roles 
instead of hardcoded credentials.

---

## Tools used

- **Docker** — multi-stage build to keep the image small (~150MB not ~900MB)
- **GitHub Actions** — CI pipeline that builds and pushes the image on every commit
- **Jenkins** — bumps the image tag in values.yaml and triggers ArgoCD
- **AWS ECR** — private Docker registry inside my AWS account
- **Helm** — packages the Kubernetes deployment so one chart works for dev, staging, and production
- **ArgoCD** — watches the GitHub repo and auto-deploys when values.yaml changes
- **Kubernetes / EKS** — runs the containers, handles scaling and self-healing
- **Terraform** — builds the entire AWS infrastructure as code — VPC, EKS, IAM, ECR
- **Prometheus + Grafana** — monitors pod metrics and shows dashboards

---

## Folder structure
app/                 The Node.js application and Dockerfile

helm/myrocketapp/    Helm chart with values.yaml for each environment

jenkins/             Jenkinsfile defining all 6 pipeline stages

kubernetes/          Kubernetes manifests and ArgoCD Application config

terraform/           All AWS infrastructure defined as Terraform code

.github/workflows/   GitHub Actions CI workflow

---

## Some decisions I made along the way

I set replicaCount to 3 in production — not 1 or 2. With 3 replicas spread
across 3 Availability Zones, even if one entire AZ goes down, the app keeps
running. With 2 replicas you can end up with zero pods in one zone.

I set maxUnavailable to 0 in the rolling update strategy. This means Kubernetes
never kills an old pod before the new one is fully ready. Zero-downtime updates,
every time.

I added a PodDisruptionBudget with minAvailable: 2. During a cluster upgrade
or node drain, Kubernetes now knows it must keep at least 2 pods alive. Without
this, it could evict all pods at once.

The Docker image runs as a non-root user called appuser. Even if the app is
compromised, the attacker gets no root access inside the container. This is
enforced in both the Dockerfile and the Kubernetes securityContext.

Resource limits are set on every pod — 500m CPU and 512Mi memory. Without
limits, one misbehaving pod can starve all others on the same node and cause
OOMKilled errors across the cluster.

---

## Current status

The GitHub Actions pipeline is passing — you can see the green badge above.
The Dockerfile, Helm chart, and Kubernetes manifests are complete and
production-ready. Terraform and the full ArgoCD deployment are still in
progress — I am building them incrementally to avoid unnecessary AWS costs
while the architecture is being refined.

---

*Divya Bharathi Prasannakumar — DevOps Engineer — Friedberg, Germany*
