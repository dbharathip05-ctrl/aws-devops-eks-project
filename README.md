# AWS DevOps EKS Platform

End-to-end AWS DevOps project demonstrating cloud infrastructure provisioning, CI/CD automation, containerization, and Kubernetes deployment using Terraform, Jenkins, Docker, and Amazon EKS.

## Key Highlights
- AWS Infrastructure provisioning with Terraform
- Kubernetes deployment on Amazon EKS
- CI/CD pipeline using Jenkins
- Docker image build and AWS ECR integration
- Helm-based Kubernetes deployments
- Monitoring-ready and production-style setup

**AWS Region:** ap-south-1 (Mumbai)

---

## Architecture Overview

GitHub → Jenkins CI/CD → Docker Build → AWS ECR → Amazon EKS → Kubernetes Deployment via Helm

## Skills Demonstrated

- AWS Cloud Infrastructure
- Terraform (Infrastructure as Code)
- Kubernetes (Amazon EKS)
- Docker Containerization
- CI/CD Automation
- Jenkins Pipelines
- Helm Deployments
- Monitoring & Cloud Operations
- DevOps Best Practices
```

---

## Tools & Technologies

| Category        | Tool / Service                                      |
|-----------------|-----------------------------------------------------|
| Cloud           | AWS (EKS, ECR, VPC, IAM, S3, ap-south-1)           |
| Infrastructure  | Terraform (VPC module + EKS module)                 |
| CI/CD           | Jenkins (declarative pipeline)                      |
| Code Quality    | SonarQube (SAST scanning)                           |
| Containers      | Docker, AWS ECR                                     |
| Orchestration   | Kubernetes (EKS 1.30), Helm                         |
| Ingress         | Nginx Ingress Controller                            |
| Scripting       | Bash, Groovy (Jenkinsfile)                          |
| Version Control | Git / GitHub                                        |

---

## Repository Structure

- terraform/ → AWS infrastructure provisioning
- app/ → Sample Node.js application
- jenkins/ → Jenkins CI/CD pipelines
- kubernetes/ → Kubernetes manifests
- helm/ → Helm chart deployment
- scripts/ → Automation scripts

## Project Objective

This project was created to practice and demonstrate hands-on DevOps and AWS Cloud Engineering skills including infrastructure automation, Kubernetes orchestration, CI/CD implementation, and cloud operations workflows.


```

---

## Screenshots

> Screenshots will be added after first successful deployment

### Jenkins Pipeline — All Stages Green
<!-- ![Jenkins Pipeline](docs/jenkins-pipeline.png) -->

### SonarQube Code Quality Report
<!-- ![SonarQube](docs/sonarqube-report.png) -->

### EKS Nodes Running
<!-- ![EKS Nodes](docs/eks-nodes.png) -->

### Application Running via Nginx Ingress
<!-- ![App](docs/app-running.png) -->

---

## How to Deploy

### Prerequisites
- AWS account with IAM user (Access Key + Secret Key)
- Jenkins EC2 server (t2.large, Ubuntu 22.04)
- All tools installed via `scripts/install-all-tools.sh`

## Deployment Workflow

1. Provision AWS infrastructure using Terraform
2. Configure EKS cluster access
3. Build Docker image and push to AWS ECR
4. Run Jenkins CI/CD pipeline
5. Deploy application to Kubernetes using Helm
```

---

## Cost Warning

| Resource | Cost |
|----------|------|
| EKS Control Plane | ~$0.10/hour |
| 2x t3.medium nodes | ~$0.084/hour |
| NAT Gateway | ~$0.045/hour |
| **Total** | **~$0.23/hour (~$5.50/day)** |

⚠️ Always run `terraform destroy` after practice to stop charges!


---

## Author

## Author

Divya Bharathi Prasannakumar  
AWS Cloud & DevOps Engineer  
Friedberg, Germany  

- AWS Certified Solutions Architect – Associate
- Terraform | Kubernetes | CI/CD | Docker | AWS

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?logo=linkedin)](https://linkedin.com/in/divya-bharathi-prasannakumar)
[![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github)](https://github.com/dbharathip05-ctrl)
