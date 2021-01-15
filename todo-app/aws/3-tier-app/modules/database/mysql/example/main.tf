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

#Add security group
module "mysql_sg" {
  source                 = "terraform-aws-modules/security-group/aws//modules/mysql"
  version                = "3.17.0"
  name                   = "security-group-${local.name_suffix}-mysql"
  vpc_id                 = module.vpc.vpc_id
  description            = "Test mysql database connection"
  use_name_prefix        = false
  auto_ingress_with_self = []
 # auto_ingress_rules     = []
  ingress_cidr_blocks    = ["0.0.0.0/0"]

  tags = merge(local.tags, {
    App = "mysql"
  })
}

module "mysql" {
  source = "../"
  app = {
    id      = "psi"
    version = "1.0.0"
    env     = "lab"
  }
  instance_type   = "db.t2.micro"
  master_user     = "masteruser"
  master_password = "masterpassword"
  multi_az        = false
}