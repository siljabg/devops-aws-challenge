terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.22"
    }
  }
}

provider "aws" {
  region = var.region
  # profile = "default"

  default_tags {
    tags = {
      Project = var.project_name
      Owner   = var.owner_name
    }
  }
}