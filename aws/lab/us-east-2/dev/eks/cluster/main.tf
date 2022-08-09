locals {
  k8s_version = 1.19

}

module "dev_eks" {
  source                   = "../../../../../modules/eks//cluster"
  app                      = var.app
  vpc_id                   = data.terraform_remote_state.vpc_dev.outputs.id
  subnet_ids               = data.terraform_remote_state.vpc_dev.outputs.private_subnets
  self_managed_node_groups = local.self_managed_node_groups
}
