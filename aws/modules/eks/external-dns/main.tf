locals {
  external_dns_namespace = "external-dns"
  zones = {
    for domain in var.domain_filters :
    domain => {
      domain_name = domain
      comment     = "Public"
    }
  }

}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = "6.6.0"
  namespace  = local.external_dns_namespace
  values = [
    templatefile("${path.module}/values.tftpl", {
      AWS_REGION            = var.aws_region
      DOMAIN_FILTERS        = sort(keys(module.zones.route53_zone_name)) #var.domain_filters
      IAM_ROLE_EXTERNAL_DNS = module.external_dns_irsa_role.iam_role_arn
  })]
}

module "external_dns_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                     = "${var.environment}-external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/*"]

  oidc_providers = {
    ex = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["kube-system:${local.external_dns_namespace}"]
    }
  }

  tags = var.tags
}


module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"
  zones   = local.zones
  tags    = var.tags
}