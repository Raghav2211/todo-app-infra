data "aws_region" "current" {}

locals {
  name_suffix = "${data.aws_region.current.name}-${substr(var.app.env, 0, 1)}-${var.app.id}${var.app.name}"
}

module "sg_mysql" {
  source                 = "terraform-aws-modules/security-group/aws//modules/mysql"
  version                = "3.17.0"
  name                   = "security-group-${local.name_suffix}-mysql"
  vpc_id                 = var.vpc_id
  description            = var.description
  use_name_prefix        = false
  auto_ingress_with_self = []
  auto_ingress_rules     = []
  computed_ingress_with_source_security_group_id = [for app_sg_id in var.app_sg_ids :
    {
      rule                     = "mysql-tcp"
      source_security_group_id = app_sg_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  tags = {
    AppId       = var.app.id
    App         = var.app.name
    Version     = var.app.version
    Role        = "infra"
    Environment = var.app.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}