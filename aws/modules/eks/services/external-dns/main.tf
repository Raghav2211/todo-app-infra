locals {
  external_dns_namespace = "external-dns"
  tags = {
    account     = var.app.account
    project     = "apps"
    environment = var.app.environment
    application = "external-dns"
    team        = "sre"
  }
  hosted_zone_ids_arns = [for host_zone_id in var.hosted_zones_ids : "arn:aws:route53:::hostedzone/${host_zone_id}"]
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  version          = "6.6.0"
  namespace        = local.external_dns_namespace
  create_namespace = true
  values = [
    templatefile("${path.module}/../values/external-dns.tftpl", {
      AWS_REGION            = data.aws_region.current.name
      DOMAIN_FILTERS        = var.hosted_zones_name
      IAM_ROLE_EXTERNAL_DNS = module.external_dns_irsa_role.iam_role_arn
  })]
}

module "external_dns_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                     = "${var.app.environment}-external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = local.hosted_zone_ids_arns

  oidc_providers = {
    ex = {
      provider_arn               = data.terraform_remote_state.eks.outputs.oidc_provider_arn
      namespace_service_accounts = ["${local.external_dns_namespace}:${local.external_dns_namespace}"]
    }
  }

  tags = local.tags
}