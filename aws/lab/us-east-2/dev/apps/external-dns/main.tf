module "dev_external_dns" {
  source                             = "../../../../../modules/apps//external-dns"
  app                                = var.app
  cluster_id                         = data.terraform_remote_state.eks_dev.outputs.cluster_id
  cluster_endpoint                   = data.terraform_remote_state.eks_dev.outputs.cluster_endpoint
  cluster_certificate_authority_data = data.terraform_remote_state.eks_dev.outputs.cluster_certificate_authority_data
  domain_filters                     = keys(data.terraform_remote_state.global_route53.outputs.route53_zone_name)
  oidc_provider_arn                  = data.terraform_remote_state.eks_dev.outputs.oidc_provider_arn
}