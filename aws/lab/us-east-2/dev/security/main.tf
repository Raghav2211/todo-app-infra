data "aws_region" "current" {}

locals {
  tags = {
    account     = var.app.account
    project     = "security"
    environment = var.app.environment
    application = "vpc"
    team        = "sre"
  }
  default_mysql_computed_ingress = [{
    rule                     = "mysql-tcp"
    source_security_group_id = module.todo_app_sg.this_security_group_id
  }]
  default_todo_app_computed_ingress = [{
    rule                     = "http-8080-tcp"
    source_security_group_id = module.todo_app_load_balancer_sg.this_security_group_id
  }]
}

module "todo_app_load_balancer_sg" {
  source                 = "terraform-aws-modules/security-group/aws//modules/http-80"
  version                = "3.17.0"
  name                   = "${var.app.environment}-todo-app-lb"
  vpc_id                 = data.terraform_remote_state.vpc_dev.outputs.id
  description            = var.todo_lb_description
  ingress_cidr_blocks    = var.todo_app_lb_ingress_cidrs
  use_name_prefix        = false
  auto_ingress_with_self = []
  auto_ingress_rules     = concat(["http-80-tcp"], var.todo_app_lb_https_ingress ? ["https-443-tcp"] : [])

  tags = merge(local.tags, {
    app = "todo-app-lb"
  })
}

module "todo_app_sg" {
  source                                                   = "terraform-aws-modules/security-group/aws//modules/http-8080"
  version                                                  = "3.17.0"
  name                                                     = "${var.app.environment}-todo-app"
  vpc_id                                                   = data.terraform_remote_state.vpc_dev.outputs.id
  description                                              = var.todo_app_description
  use_name_prefix                                          = false
  auto_ingress_with_self                                   = []
  auto_ingress_rules                                       = []
  computed_ingress_with_source_security_group_id           = local.default_todo_app_computed_ingress
  number_of_computed_ingress_with_source_security_group_id = length(local.default_todo_app_computed_ingress)

  tags = merge(local.tags, {
    app = "todo-app"
  })
}

module "mysql_sg" {
  source                                                   = "terraform-aws-modules/security-group/aws//modules/mysql"
  version                                                  = "3.17.0"
  name                                                     = "${var.app.environment}-mysql"
  vpc_id                                                   = data.terraform_remote_state.vpc_dev.outputs.id
  description                                              = var.mysql_description
  use_name_prefix                                          = false
  auto_ingress_with_self                                   = []
  auto_ingress_rules                                       = []
  computed_ingress_with_source_security_group_id           = local.default_mysql_computed_ingress
  number_of_computed_ingress_with_source_security_group_id = length(local.default_mysql_computed_ingress)

  tags = merge(local.tags, {
    app = "mysql"
  })
}