variable "environment" {
  description = "The environment name (dev, staging, prod)"
  type        = string
}

variable "eks_cluster_role_arn" {
  type = string
}

variable "private_subnet_ids_list" {
  type = list(string)
}

variable "eks_version" {
  description = "The Kubernetes version for the EKS cluster"
  type        = string
}

variable "eks_node_group_role_arn" {
  type = string
}

variable "instance_types" {
  description = "List of EC2 instance types for the EKS worker nodes"
  type        = list(string)
}
