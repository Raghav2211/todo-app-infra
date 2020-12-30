provider "aws" {
  region = var.region
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

###############################
#             VPC             #
###############################
module "vpc" {
  source           = "../modules/network"
  app_name         = var.app_name
  app_version      = var.app_version
  env              = var.env
  cidr             = var.cidr
  azs              = var.azs
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets
}

###############################
#       Security Groups       #
###############################
module "bastion_ssh" {
  source       = "../modules/sg/ssh"
  app_name     = var.app_name
  app_version  = var.app_version
  env          = var.env
  name_suffix  = "bastion"
  vpc_id       = module.vpc.vpc_id
  description  = "Bastion host security group"
  ingress_cidr = concat(var.sg_bastion_ingress_cidrs, ["${chomp(data.http.myip.body)}/32"])

}

module "loadbalancer_http_80_443" {
  source       = "../modules/sg/http-80-443"
  app_name     = var.app_name
  app_version  = var.app_version
  env          = var.env
  name_suffix  = "lb"
  vpc_id       = module.vpc.vpc_id
  description  = "Load Balancer host security group"
  ingress_cidr = concat(var.sg_loadbalancer_ingress_cidrs, ["0.0.0.0/0"])

}
