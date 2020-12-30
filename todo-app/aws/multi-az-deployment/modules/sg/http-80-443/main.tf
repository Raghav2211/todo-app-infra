module "sg_http_80_443" {
  source                 = "terraform-aws-modules/security-group/aws//modules/http-80"
  version                = "3.17.0"
  name                   = "${var.app_name}-${var.env}${var.name_suffix != "" ? "-${var.name_suffix}" : ""}"
  vpc_id                 = var.vpc_id
  description            = var.description
  ingress_cidr_blocks    = var.ingress_cidr
  use_name_prefix        = false
  auto_ingress_with_self = []
  auto_ingress_rules     = concat(["http-80-tcp"], var.http443enable ? ["https-443-tcp"] : [])

  tags = {
    AppId       = var.app_id
    App         = var.app_name
    Version     = var.app_version
    Role        = "infra"
    Environment = var.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}