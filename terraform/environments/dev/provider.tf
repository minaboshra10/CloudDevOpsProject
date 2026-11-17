terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "clouddevops-tfstate-746491202405-1794781445"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    profile      = "clouddevops"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "clouddevops"
}
