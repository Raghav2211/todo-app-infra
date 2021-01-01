data "aws_region" "current" {}

locals {
  name_suffix = "${data.aws_region.current.name}-${substr(var.app.env, 0, 1)}-${var.app.id}${var.app.name}"
}

module "sg_load_balancer" {
  source                 = "terraform-aws-modules/security-group/aws//modules/http-80"
  version                = "3.17.0"
  name                   = "security-group-${local.name_suffix}-lb"
  vpc_id                 = var.vpc_id
  description            = var.sg_lb_description
  ingress_cidr_blocks    = var.ingress_cidrs
  use_name_prefix        = false
  auto_ingress_with_self = []
  auto_ingress_rules     = concat(["http-80-tcp"], var.http443enable ? ["https-443-tcp"] : [])

  tags = {
    AppId       = var.app.id
    App         = var.app.name
    Version     = var.app.version
    Role        = "infra"
    Environment = var.app.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}

module "sg_app" {
  source                 = "terraform-aws-modules/security-group/aws//modules/http-8080"
  version                = "3.17.0"
  name                   = "security-group-${local.name_suffix}-app"
  vpc_id                 = var.vpc_id
  description            = var.sg_app_description
  use_name_prefix        = false
  auto_ingress_with_self = []
  auto_ingress_rules     = []
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = var.bastion_sg_id
    },
    {
      rule                     = "http-8080-tcp"
      source_security_group_id = module.sg_load_balancer.this_security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 2

  tags = {
    AppId       = var.app.id
    App         = var.app.name
    Version     = var.app.version
    Role        = "infra"
    Environment = var.app.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}