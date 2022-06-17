locals {
  tags = {
    account     = var.app.account
    project     = "security"
    environment = var.app.environment
    application = "rds"
    team        = "sre"
  }
  # default_mysql_computed_ingress = [{
  #   rule                     = "mysql-tcp"
  #   source_security_group_id = module.todo_app_sg.this_security_group_id
  # }]
}

module "mysql_sg" {
  source                 = "terraform-aws-modules/security-group/aws//modules/mysql"
  version                = "3.17.0"
  name                   = "${var.app.environment}-mysql"
  vpc_id                 = data.terraform_remote_state.vpc_dev.outputs.id
  description            = var.mysql_description
  use_name_prefix        = false
  auto_ingress_with_self = []
  auto_ingress_rules     = []
  #computed_ingress_with_source_security_group_id           = local.default_mysql_computed_ingress
  #number_of_computed_ingress_with_source_security_group_id = length(local.default_mysql_computed_ingress)

  tags = merge(local.tags, {
    app = "mysql"
  })
}