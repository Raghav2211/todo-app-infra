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
  required_version = "= 0.13.5"
}

provider "aws" {
  version = ">= 2.28.1"
  region  = var.region
}

provider "local" {
  version = "~> 1.2"
}