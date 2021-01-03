provider "aws" {
  region = var.region
}

locals {
  app_vars = {
    id      = "psi"
    version = var.app_version
    env     = var.env
  }
}

module "vpc" {
  source           = "../../modules/network"
  app              = local.app_vars
  cidr             = var.cidr
  azs              = var.azs
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets
}