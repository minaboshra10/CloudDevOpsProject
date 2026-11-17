variable "project_name" {
  description = "Project name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.37"
}

variable "private_subnet_ids" {
  description = "Two private subnet IDs in different availability zones"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) == 2
    error_message = "Exactly two private subnet IDs are required."
  }
}

variable "allowed_cluster_cidr" {
  description = "CIDR allowed to access the EKS public API endpoint"
  type        = string
}

variable "node_instance_types" {
  description = "EC2 instance types for EKS worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}
