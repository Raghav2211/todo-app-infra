locals {
  tags = {
    account     = var.app.account
    project     = "security"
    environment = var.app.environment
    application = "mongo"
    team        = "sre"
  }
}

module "mongo_sg" {
  source                 = "terraform-aws-modules/security-group/aws//modules/mongodb"
  version                = "3.17.0"
  name                   = "${var.app.environment}-mongo"
  vpc_id                 = data.terraform_remote_state.vpc_dev.outputs.id
  description            = var.mongo_description
  use_name_prefix        = false
  ingress_cidr_blocks    = [data.terraform_remote_state.vpc_dev.outputs.cidr]
  ingress_rules          = ["mongodb-27017-tcp"]
  revoke_rules_on_delete = true
  tags = merge(local.tags, {
    app = "mongo"
  })
}