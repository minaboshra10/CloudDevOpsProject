output "repository_urls" {
  description = "URLs of the ECR repositories"

  value = {
    for name, repository in aws_ecr_repository.main :
    name => repository.repository_url
  }
}
