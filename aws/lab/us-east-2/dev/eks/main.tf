module "dev_eks" {
  source                         = "../../../../modules/eks"
  app                            = var.app
  vpc_id                         = data.terraform_remote_state.vpc_dev.outputs.id
  public_subnet_ids              = data.terraform_remote_state.vpc_dev.outputs.public_subnets
  private_subnet_ids             = data.terraform_remote_state.vpc_dev.outputs.private_subnets
  bottlerocket_node_group_config = var.node_group_config
}