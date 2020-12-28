terraform {

  backend "remote" {
    organization = "psi-lab"

    workspaces {
      name = "gh-actions-demo"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.21.0"
    }
  }
  required_version = ">= 0.12"
}