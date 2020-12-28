provider "aws" {
  region = var.region
}

module "vpc" {
  source           = "../modules/network"
  app_name         = var.app_name
  app_version      = var.app_version
  env              = "lab"
  cidr             = var.cidr
  azs              = var.azs
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets
}

