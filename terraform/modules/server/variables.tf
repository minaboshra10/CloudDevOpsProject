variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for Jenkins server"
  type        = string
}

variable "subnet_id" {
  description = "Public subnet ID"
  type        = string
}

variable "key_name" {
  description = "EC2 SSH key pair name"
  type        = string
}

variable "public_key" {
  description = "SSH public key content"
  type        = string
}

variable "allowed_cidr" {
  description = "CIDR allowed to access SSH and Jenkins"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "root_volume_size" {
  description = "EC2 root volume size in GiB"
  type        = number
  default     = 20
}
