provider "aws" {
  region = var.region
}

module "vpc" {
  source           = "../modules/network"
  name             = var.name
  env              = "lab"
  cidr             = var.cidr
  azs              = var.azs
  public_subnets   = var.public_subnets
  intra_subnets    = var.intra_subnets
  database_subnets = var.database_subnets
}

