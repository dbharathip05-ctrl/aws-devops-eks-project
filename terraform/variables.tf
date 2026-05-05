##############################################################
# terraform/variables.tf
##############################################################

variable "aws_region" {
  description = "AWS region — Mumbai is closest to you"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "divya-eks-cluster"
}

variable "account_id" {
  description = "051797965283"
  type        = string
  default     = "051797965283"
}
