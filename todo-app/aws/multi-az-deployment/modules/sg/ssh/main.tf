module "sg_ssh" {
  source                 = "terraform-aws-modules/security-group/aws//modules/ssh"
  version                = "3.17.0"
  name                   = "${var.app_vars.name}-${var.app_vars.env}${var.name_suffix != "" ? "-${var.name_suffix}" : ""}"
  vpc_id                 = var.vpc_id
  description            = var.description
  ingress_cidr_blocks    = var.ingress_cidr
  use_name_prefix        = false
  auto_ingress_with_self = []

  tags = {
    AppId       = var.app_id
    App         = var.app_vars.name
    Version     = var.app_vars.version
    Role        = "infra"
    Environment = var.app_vars.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}