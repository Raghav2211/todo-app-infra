module "dev_external_dns" {
  source            = "../../../../../modules/apps//external-dns"
  app               = var.app
  domain_filters    = var.domain_filters
  oidc_provider_arn = data.terraform_remote_state.eks_dev.outputs.oidc_provider_arn
}