provider "aws" {
  region = var.region
}

data "aws_region" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["vpc-${local.name_suffix}"]
  }
}

data "http" "myip" {
  count = var.env_cidr_block ? 1 : 0
  url   = "http://ipv4.icanhazip.com"
}

locals {
  name_suffix = "${data.aws_region.current.name}-${substr(var.app.env, 0, 1)}-${var.app.id}"
  tags = {
    AppId       = var.app.id
    Version     = var.app.version
    Role        = "security"
    Environment = var.app.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}

module "bastion_sg" {
  source                 = "terraform-aws-modules/security-group/aws//modules/ssh"
  version                = "3.17.0"
  name                   = "security-group-${local.name_suffix}-bastion"
  vpc_id                 = data.aws_vpc.selected.id
  description            = var.bastion_description
  ingress_cidr_blocks    = concat(var.bastion_ingress_cidrs, var.env_cidr_block ? ["${chomp(data.http.myip[0].body)}/32"] : [])
  use_name_prefix        = false
  auto_ingress_with_self = []

  tags = merge(local.tags, {
    App = "bastion"
  })
}


module "todo_app_load_balancer_sg" {
  source                 = "terraform-aws-modules/security-group/aws//modules/http-80"
  version                = "3.17.0"
  name                   = "security-group-${local.name_suffix}-todo-lb"
  vpc_id                 = data.aws_vpc.selected.id
  description            = var.todo_lb_description
  ingress_cidr_blocks    = var.todo_app_lb_ingress_cidrs
  use_name_prefix        = false
  auto_ingress_with_self = []
  auto_ingress_rules     = concat(["http-80-tcp"], var.todo_app_lb_https_ingress ? ["https-443-tcp"] : [])

  tags = merge(local.tags, {
    App = "todoapp"
  })
}

module "todo_app_sg" {
  source                 = "terraform-aws-modules/security-group/aws//modules/http-8080"
  version                = "3.17.0"
  name                   = "security-group-${local.name_suffix}-todo-app"
  vpc_id                 = data.aws_vpc.selected.id
  description            = var.todo_app_description
  use_name_prefix        = false
  auto_ingress_with_self = []
  auto_ingress_rules     = []
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.bastion_sg.this_security_group_id
    },
    {
      rule                     = "http-8080-tcp"
      source_security_group_id = module.todo_app_load_balancer_sg.this_security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 2

  tags = merge(local.tags, {
    App = "todoapp"
  })
}

module "todo_mysql_sg" {
  source                 = "terraform-aws-modules/security-group/aws//modules/mysql"
  version                = "3.17.0"
  name                   = "security-group-${local.name_suffix}-todo-mysql"
  vpc_id                 = data.aws_vpc.selected.id
  description            = var.todo_mysql_description
  use_name_prefix        = false
  auto_ingress_with_self = []
  auto_ingress_rules     = []
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.todo_app_sg.this_security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  tags = merge(local.tags, {
    App = "todoapp"
  })
}