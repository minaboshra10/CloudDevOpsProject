
module "network" {
  source = "../../modules/network"

  project_name             = "cloud_devops"
  vpc_cidr                 = "10.0.0.0/16"
  availability_zones_count = 2
  enable_nat_gateway       = true

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}

module "server" {
  source = "../../modules/server"

  project_name = "cloud_devops"
  vpc_id       = module.network.vpc_id
  subnet_id    = module.network.public_subnet_ids[0]

  key_name         = "clouddevops-jenkins"
  public_key       = file(pathexpand("~/.ssh/clouddevops-jenkins.pub"))
  allowed_cidr     = "156.209.141.238/32"
  instance_type    = "t3.small"
  root_volume_size = 20
}

module "eks" {
  source = "../../modules/eks"

  project_name         = "cloud_devops"
  cluster_version      = "1.37"
  private_subnet_ids   = module.network.private_subnet_ids
  allowed_cluster_cidr = "156.209.141.238/32"
  node_instance_types  = ["t3.small"]
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = "cloud_devops"

  repository_names = [
    "frontend",
    "auth-service",
    "roadmap-service"
  ]
}
