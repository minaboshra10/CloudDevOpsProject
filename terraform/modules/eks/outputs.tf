output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "node_group_names" {
  description = "EKS managed node group names"
  value       = aws_eks_node_group.main[*].node_group_name
}

output "node_group_role_arn" {
  description = "EKS worker node IAM role ARN"
  value       = aws_iam_role.node_group.arn
}
