terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.18.0"
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
    local = {
      source  = "hashicorp/local"
      version = "~> 1.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "= 3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.10"
    }
  }
  required_version = "= 1.2.2"
}

provider "aws" {
  region = var.app.region
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}