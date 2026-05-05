##############################################################
# terraform/outputs.tf
# These values print after terraform apply — save them!
##############################################################

output "cluster_name" {
  description = "EKS Cluster Name — use in aws eks update-kubeconfig"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS API endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_arn" {
  description = "EKS Cluster ARN"
  value       = module.eks.cluster_arn
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "ecr_repo_url" {
  description = "Your ECR repository URL for Docker images"
  value       = "051797965283.dkr.ecr.ap-south-1.amazonaws.com/divya-app"
}

output "kubeconfig_command" {
  description = "Run this command to connect kubectl to your cluster"
  value       = "aws eks update-kubeconfig --name divya-eks-cluster --region ap-south-1"
}
