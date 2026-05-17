# AWS DevOps EKS Platform

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-D24939?logo=jenkins&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![AWS](https://img.shields.io/badge/AWS_EKS-FF9900?logo=amazonaws&logoColor=white)
![SonarQube](https://img.shields.io/badge/SonarQube-4E9BCD?logo=sonarqube&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-0F1689?logo=helm&logoColor=white)

End-to-end DevOps platform automating infrastructure provisioning and
application deployment on AWS using Terraform, Jenkins, Docker, Kubernetes (EKS), and Helm.

**AWS Region:** ap-south-1 (Mumbai)

---

## Architecture

```
Developer Laptop
       │
       │  git push
       ▼
   GitHub Repo ──── webhook ────► Jenkins Server (EC2)
                                        │
                           ┌────────────┼────────────┐
                           ▼            ▼             ▼
                       SonarQube    Docker Build   npm test
                       SAST Scan    + ECR Push
                                        │
                                        ▼
                                 AWS ECR Registry
                              (051797965283.dkr.ecr
                               .ap-south-1.amazonaws.com)
                                        │
                                   Helm Deploy
                                        │
                                        ▼
                              AWS EKS Cluster
                           (divya-eks-cluster)
                          ┌────────┴────────┐
                          ▼                 ▼
                        Pod 1             Pod 2
                     (Node.js)         (Node.js)
                          │
                   Nginx Ingress Controller
                          │
                          ▼
                       Users 🌐
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

```
aws-devops-eks-project/
├── terraform/                  ← IaC — builds VPC + EKS on AWS
│   ├── main.tf                 ← VPC + EKS modules
│   ├── variables.tf            ← region, cluster name
│   └── outputs.tf              ← cluster endpoint, ECR URL
│
├── app/                        ← Node.js application
│   ├── server.js               ← Express web server
│   ├── package.json
│   └── Dockerfile              ← container image definition
│
├── jenkins/
│   ├── Jenkinsfile             ← CI/CD pipeline (SCM→Sonar→Docker→ECR→EKS)
│   ├── Jenkinsfile.terraform   ← infrastructure pipeline (Plan/Apply/Destroy)
│   └── docker-compose.yaml    ← SonarQube + PostgreSQL setup
│
├── kubernetes/app/
│   ├── deployment.yaml         ← 2 replicas, rolling update, health checks
│   ├── service.yaml            ← ClusterIP service
│   └── ingress.yaml            ← Nginx ingress routing
│
├── helm/myrocketapp/
│   ├── Chart.yaml
│   ├── values.yaml             ← image repo, replicas, resources
│   └── templates/deployment.yaml ← Helm template with variable substitution
│
├── scripts/
│   ├── install-all-tools.sh    ← installs AWS CLI, kubectl, eksctl, Helm
│   └── setup-eks-access.sh    ← connects kubectl + installs Nginx Ingress
│
└── docs/                       ← screenshots (added after deployment)
    ├── architecture.png
    ├── jenkins-pipeline.png
    ├── sonarqube-report.png
    ├── eks-nodes.png
    └── app-running.png
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

### Step 1 — Create S3 bucket for Terraform state
```bash
aws s3 mb s3://divya-tf-state-051797965283 --region ap-south-1
```

### Step 2 — Provision EKS cluster with Terraform
```bash
cd terraform/
terraform init
terraform plan      # review what will be created
terraform apply -auto-approve   # takes 15-20 minutes
```

### Step 3 — Connect kubectl and install Nginx Ingress
```bash
bash scripts/setup-eks-access.sh
```

### Step 4 — Create ECR repository
```bash
aws ecr create-repository --repository-name divya-app --region ap-south-1
```

### Step 5 — Configure Jenkins and run pipeline
1. Add AWS credentials in Jenkins (Credentials → AWS Credentials → ID: `aws-credentials-divya`)
2. Create Pipeline job → SCM → this repo → Script path: `jenkins/Jenkinsfile`
3. Click Build Now
4. Watch each stage go green ✅

### Step 6 — Access the application
```bash
kubectl get ingress   # copy the ADDRESS column
# Open in browser → your app is live!
```

### Step 7 — Destroy when done (stop AWS charges)
```bash
cd terraform/
terraform destroy -auto-approve
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

**Divya Bharathi Prasannakumar**
DevOps Engineer | Friedberg, Germany  |
Permanent Residence  | English C1 | German B2

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?logo=linkedin)](https://linkedin.com/in/divya-bharathi-prasannakumar)
[![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github)](https://github.com/dbharathip05-ctrl)
