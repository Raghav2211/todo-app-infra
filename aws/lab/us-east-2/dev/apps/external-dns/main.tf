module "dev_external_dns" {
  source            = "../../../../../modules/apps//external-dns"
  app               = var.app
  hosted_zones_name = data.terraform_remote_state.global_route53.outputs.route53_zone_names
  hosted_zones_ids  = data.terraform_remote_state.global_route53.outputs.route53_zone_ids
}