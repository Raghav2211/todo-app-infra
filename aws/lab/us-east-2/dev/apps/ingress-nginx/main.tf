module "dev_ingress_nginx_controller" {
  source                             = "../../../../../modules/apps//ingress-nginx"
  cluster_id                         = data.terraform_remote_state.eks_dev.outputs.cluster_id
  cluster_endpoint                   = data.terraform_remote_state.eks_dev.outputs.cluster_endpoint
  cluster_certificate_authority_data = data.terraform_remote_state.eks_dev.outputs.cluster_certificate_authority_data
}