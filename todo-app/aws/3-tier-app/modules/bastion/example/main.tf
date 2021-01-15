provider "aws" {
  region = "us-west-2"
}

locals {
  name_suffix = "us-west-2-l-psi"
  tags = {
    AppId       = "psi"
    Version     = "1.0.0"
    Role        = "security"
    Environment = "lab"
  }
}

# Add VPC
module "vpc" {
  source = "../../network/example"
}

# Add security group
module "bastion_sg" {
  source                 = "terraform-aws-modules/security-group/aws//modules/ssh"
  version                = "3.17.0"
  name                   = "security-group-${local.name_suffix}-bastion"
  vpc_id                 = module.vpc.vpc_id
  description            = "Bastion security group"
  ingress_cidr_blocks    = ["0.0.0.0/0"]
  use_name_prefix        = false
  auto_ingress_with_self = []
  tags = merge(local.tags, {
    App = "bastion"
  })
}

module "bastion" {
  source = "../"
  app = {
    id      = "psi"
    name    = "todo"
    version = "1.0.0"
    env     = "lab"
  }
  ssh_users = [
    {
      username   = "bastionuser"
      public_key = "PLACE-YOUR-SSH-PUBLIC-KEY-HERE"
    }
  ]
}