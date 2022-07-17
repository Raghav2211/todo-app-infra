locals {
  zones = {
    for domain in var.domain_filters :
    domain => {
      domain_name   = domain
      comment       = "Public"
      force_destroy = true
    }
  }
  tags = {
    account     = var.app.account
    project     = "apps"
    environment = var.app.environment
    application = "external-dns"
    team        = "sre"
  }
}

module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"
  zones   = local.zones
  tags    = local.tags
}