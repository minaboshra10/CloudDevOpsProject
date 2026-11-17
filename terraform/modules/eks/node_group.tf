resource "aws_eks_node_group" "main" {
  count = 2

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-node-group-${count.index + 1}"
  node_role_arn   = aws_iam_role.node_group.arn

  subnet_ids = [
    var.private_subnet_ids[count.index]
  ]

  instance_types = var.node_instance_types
  capacity_type  = "ON_DEMAND"
  disk_size      = 20

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node,
    aws_iam_role_policy_attachment.ecr_read_only,
    aws_iam_role_policy_attachment.cni
  ]

  tags = {
    Name = "${var.project_name}-eks-worker-${count.index + 1}"
  }
}
