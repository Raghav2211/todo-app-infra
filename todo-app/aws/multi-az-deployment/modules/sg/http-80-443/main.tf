module "sg_http_80_443" {
  source                 = "terraform-aws-modules/security-group/aws//modules/http-80"
  version                = "3.17.0"
  name                   = "${var.app_vars.name}-${var.app_vars.env}${var.name_suffix != "" ? "-${var.name_suffix}" : ""}"
  vpc_id                 = var.vpc_id
  description            = var.description
  ingress_cidr_blocks    = var.ingress_cidr
  use_name_prefix        = false
  auto_ingress_with_self = []
  auto_ingress_rules     = concat(["http-80-tcp"], var.http443enable ? ["https-443-tcp"] : [])

  tags = {
    AppId       = var.app_id
    App         = var.app_vars.name
    Version     = var.app_vars.version
    Role        = "infra"
    Environment = var.app_vars.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}