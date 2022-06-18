locals {
  tags = {
    account     = var.app.account
    project     = "security"
    environment = var.app.environment
    application = "rds"
    team        = "sre"
  }
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
  tags = merge(local.tags, {
    app = "mysql"
  })
}