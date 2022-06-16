data "aws_region" "current" {}

data "aws_security_group" "todo_app_ssh" {
  count = var.enable_todo_app_ssh ? 1 : 0
  name  = "security-group-${local.name_suffix}-bastion"
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
  default_mysql_computed_ingress = [{
    rule                     = "mysql-tcp"
    source_security_group_id = module.todo_app_sg.this_security_group_id
  }]
  todo_app_computed_ssh_ingress = var.enable_todo_app_ssh ? [{
    rule                     = "ssh-tcp"
    source_security_group_id = data.aws_security_group.todo_app_ssh[0].id
  }] : []
  default_todo_app_computed_ingress = concat([{
    rule                     = "http-8080-tcp"
    source_security_group_id = module.todo_app_load_balancer_sg.this_security_group_id
  }], local.todo_app_computed_ssh_ingress)
}

module "todo_app_load_balancer_sg" {
  source                 = "terraform-aws-modules/security-group/aws//modules/http-80"
  version                = "3.17.0"
  name                   = "security-group-${local.name_suffix}-todo-app-lb"
  vpc_id                 = module.vpc.id
  description            = var.todo_lb_description
  ingress_cidr_blocks    = var.todo_app_lb_ingress_cidrs
  use_name_prefix        = false
  auto_ingress_with_self = []
  auto_ingress_rules     = concat(["http-80-tcp"], var.todo_app_lb_https_ingress ? ["https-443-tcp"] : [])

  tags = merge(local.tags, {
    App = "todo-app-lb"
  })
}

module "todo_app_sg" {
  source                                                   = "terraform-aws-modules/security-group/aws//modules/http-8080"
  version                                                  = "3.17.0"
  name                                                     = "security-group-${local.name_suffix}-todo-app"
  vpc_id                                                   = module.vpc.id
  description                                              = var.todo_app_description
  use_name_prefix                                          = false
  auto_ingress_with_self                                   = []
  auto_ingress_rules                                       = []
  computed_ingress_with_source_security_group_id           = local.default_todo_app_computed_ingress
  number_of_computed_ingress_with_source_security_group_id = length(local.default_todo_app_computed_ingress)

  tags = merge(local.tags, {
    App = "todo-app"
  })
}

module "mysql_sg" {
  source                                                   = "terraform-aws-modules/security-group/aws//modules/mysql"
  version                                                  = "3.17.0"
  name                                                     = "security-group-${local.name_suffix}-mysql"
  vpc_id                                                   = module.vpc.id
  description                                              = var.mysql_description
  use_name_prefix                                          = false
  auto_ingress_with_self                                   = []
  auto_ingress_rules                                       = []
  computed_ingress_with_source_security_group_id           = local.default_mysql_computed_ingress
  number_of_computed_ingress_with_source_security_group_id = length(local.default_mysql_computed_ingress)

  tags = merge(local.tags, {
    App = "mysql"
  })
}