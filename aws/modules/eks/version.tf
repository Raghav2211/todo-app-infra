terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.22.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.0.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
  required_version = "= 1.2.2"
}

provider "local" {
  version = "~> 1.2"
}

provider "aws" {
  region = var.region
}