module "sg_ssh" {
  source                 = "terraform-aws-modules/security-group/aws//modules/ssh"
  version                = "3.17.0"
  name                   = "${var.app_name}-${var.env}${var.name_suffix != "" ? "-${var.name_suffix}" : ""}"
  vpc_id                 = var.vpc_id
  description            = var.description
  ingress_cidr_blocks    = var.ingress_cidr
  use_name_prefix        = false
  auto_ingress_with_self = []

  tags = {
    AppId       = var.app_id
    App         = var.app_name
    Version     = var.app_version
    Role        = "infra"
    Environment = var.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}