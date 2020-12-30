provider "aws" {
  region = var.region
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  app_vars = {
    name    = var.app_name
    version = var.app_version
    env     = var.env
  }
}

###############################
#             VPC             #
###############################
module "vpc" {
  source           = "../modules/network"
  app_vars         = local.app_vars
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
  app_vars     = local.app_vars
  name_suffix  = "bastion"
  vpc_id       = module.vpc.vpc_id
  description  = "Bastion host security group"
  ingress_cidr = concat(var.sg_bastion_ingress_cidrs, ["${chomp(data.http.myip.body)}/32"])

}

module "loadbalancer_http_80_443" {
  source       = "../modules/sg/http-80-443"
  app_vars     = local.app_vars
  name_suffix  = "lb"
  vpc_id       = module.vpc.vpc_id
  description  = "Load Balancer host security group"
  ingress_cidr = concat(var.sg_loadbalancer_ingress_cidrs, ["0.0.0.0/0"])

}


module "app_http_8080_443_22" {
  source      = "../modules/sg/http-8080-443"
  app_vars    = local.app_vars
  name_suffix = ""
  vpc_id      = module.vpc.vpc_id
  description = "Todo App security group"
  ingress_with_sg_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.bastion_ssh.sg_id
    }
  ]

}
