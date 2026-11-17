variable "project_name" {
  description = "Project name"
  type        = string
}

variable "repository_names" {
  description = "Names of the ECR repositories"
  type        = set(string)
}
