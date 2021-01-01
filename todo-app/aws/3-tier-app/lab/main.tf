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


###############################
#             VPC             #
###############################
module "vpc" {
  source           = "../modules/network"
  app              = merge(local.app_vars, { suffix : "" })
  cidr             = var.cidr
  azs              = var.azs
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets 
}

###############################
#       Security Groups       #
###############################
module "bastion" {
  source       = "../modules/bastion"
  app          = merge(local.app_vars, { suffix : "bastion" })
  vpc_id       = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  #description  = "Bastion host security group"
  #ingress_cidr = concat(var.sg_bastion_ingress_cidrs, ["${chomp(data.http.myip.body)}/32"])

}

# module "loadbalancer_sg" {
#   source       = "../modules/sg/http-80-443"
#   app          = merge(local.app_vars, { suffix : "lb" })
#   vpc_id       = module.vpc.vpc_id
#   description  = "Load Balancer host security group"
#   ingress_cidr = concat(var.sg_loadbalancer_ingress_cidrs, ["0.0.0.0/0"])

# }


# module "app_sg" {
#   source      = "../modules/sg/http-8080-443"
#   app         = merge(local.app_vars, { suffix : "" })
#   vpc_id      = module.vpc.vpc_id
#   description = "Todo App security group"
#   ingress_with_sg_id = [
#     {
#       rule                     = "ssh-tcp"
#       source_security_group_id = module.bastion_sg.sg_id
#     },
#     {
#       rule                     = "http-8080-tcp"
#       source_security_group_id = module.loadbalancer_sg.sg_id
#     }
#   ]

# }

# module "mysql_sg" {
#   source = "../modules/sg/mysql"
#   app    = merge(local.app_vars, { suffix : "mysql" })
#   vpc_id = module.vpc.vpc_id
#   ingress_with_sg_id = [
#     {
#       rule                     = "mysql-tcp"
#       source_security_group_id = module.app_sg.sg_id
#     }
#   ]

# }
