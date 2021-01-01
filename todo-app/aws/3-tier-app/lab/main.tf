provider "aws" {
  region = var.region
}

locals {
  app_vars = {
    id      = "psi"
    name    = var.app_name
    version = var.app_version
    env     = var.env
  }
}

module "todo_vpc" {
  source           = "../modules/network"
  app              = local.app_vars
  cidr             = var.cidr
  azs              = var.azs
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets
}

module "todo_bastion" {
  source         = "../modules/bastion"
  app            = local.app_vars
  vpc_id         = module.todo_vpc.vpc_id
  public_subnets = module.todo_vpc.public_subnets

}

module "todo_mysql" {
  source     = "../modules/database/mysql"
  app        = local.app_vars
  vpc_id     = module.todo_vpc.vpc_id
  app_sg_ids = list(module.todo_app.sg_app_id)
}

module "todo_app" {
  source        = "../modules/app"
  app           = local.app_vars
  vpc_id        = module.todo_vpc.vpc_id
  bastion_sg_id = module.todo_bastion.sg_id
}

