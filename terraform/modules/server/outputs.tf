output "jenkins_instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = aws_instance.jenkins.id
}

output "jenkins_public_ip" {
  description = "Jenkins EC2 public IP"
  value       = aws_instance.jenkins.public_ip
}

output "jenkins_public_dns" {
  description = "Jenkins EC2 public DNS"
  value       = aws_instance.jenkins.public_dns
}

output "jenkins_security_group_id" {
  description = "Jenkins security group ID"
  value       = aws_security_group.jenkins.id
}

output "jenkins_key_name" {
  description = "EC2 SSH key pair name"
  value       = aws_key_pair.jenkins.key_name
}

output "jenkins_iam_role_arn" {
  description = "Jenkins EC2 IAM role ARN"
  value       = aws_iam_role.jenkins.arn
}

output "jenkins_instance_profile_name" {
  description = "Jenkins EC2 instance profile"
  value       = aws_iam_instance_profile.jenkins.name
}
