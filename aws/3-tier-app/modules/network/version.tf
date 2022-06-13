terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.22.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "= 2.2.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "= 2.0.0"
    }
  }
  required_version = "= 1.2.2"
}