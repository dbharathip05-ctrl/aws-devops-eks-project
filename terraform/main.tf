##############################################################
# terraform/main.tf
# AWS Account: 051797965283 (Dbprasannakumar)
# Region: ap-south-1 (Mumbai)
# Cluster: divya-eks-cluster
##############################################################

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # S3 backend — stores your terraform state file safely
  # Create this bucket FIRST in AWS Console before running terraform init
  backend "s3" {
    bucket = "divya-tf-state-051797965283"   # Dbprasannakumar051797965283
    key    = "eks/terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = var.aws_region   # ap-south-1
}

##############################################################
# VPC — your private network in the cloud
# Think of this as building the roads before placing the houses
##############################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  # ap-south-1 has 3 availability zones: a, b, c
  azs             = ["ap-south-1a", "ap-south-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true   # saves cost for dev/practice
  enable_dns_hostnames = true
  enable_dns_support   = true

  # These tags are REQUIRED for EKS to find your subnets
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }

  tags = {
    Project     = "divya-devops"
    ManagedBy   = "Terraform"
    Owner       = "Dbprasannakumar"
    AccountID   = "051797965283"
  }
}

##############################################################
# EKS Cluster — your Kubernetes cluster on AWS
# This is where your Docker containers will run
##############################################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = var.cluster_name        # divya-eks-cluster
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Allow kubectl access from your laptop/Jenkins server
  cluster_endpoint_public_access = true

  # Enable cluster creator (you) as admin automatically
  enable_cluster_creator_admin_permissions = true

  # EKS managed add-ons — these run system components
  cluster_addons = {
    coredns    = { most_recent = true }
    kube-proxy = { most_recent = true }
    vpc-cni    = { most_recent = true }
  }

  # Worker nodes — the computers that run your pods
  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]   # 2 vCPU, 4GB RAM — good for practice
      min_size       = 1
      max_size       = 3
      desired_size   = 2

      labels = {
        role    = "general"
        project = "divya-devops"
      }
    }
  }

  tags = {
    Project   = "divya-devops"
    ManagedBy = "Terraform"
    Owner     = "Dbprasannakumar"
  }
}
