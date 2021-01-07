provider "aws" {
  region = var.region
}

module "vpc" {
  source                       = "../../modules/network"
  app                          = var.app
  cidr                         = var.cidr
  azs                          = var.azs
  public_subnets               = var.public_subnets
  private_subnets              = var.private_subnets
  database_subnets             = var.database_subnets
  create_database_subnet_group = true
}