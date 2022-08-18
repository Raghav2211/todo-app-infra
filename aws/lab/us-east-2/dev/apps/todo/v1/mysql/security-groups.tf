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
  source              = "terraform-aws-modules/security-group/aws//modules/mysql"
  version             = "3.17.0"
  name                = "${var.app.environment}-mysql"
  vpc_id              = data.terraform_remote_state.vpc_dev.outputs.id
  description         = var.mysql_description
  use_name_prefix     = false
  ingress_cidr_blocks = [data.terraform_remote_state.vpc_dev.outputs.cidr]
  ingress_rules       = ["mysql-tcp"]
  tags = merge(local.tags, {
    app = "mysql"
  })
}