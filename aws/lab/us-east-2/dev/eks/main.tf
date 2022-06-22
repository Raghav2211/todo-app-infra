module "dev_eks" {
  source               = "../../../../modules/eks"
  app                  = var.app
  vpc_id               = data.terraform_remote_state.vpc_dev.outputs.id
  public_subnet_ids    = data.terraform_remote_state.vpc_dev.outputs.public_subnets
  nodegroup_subnet_ids = data.terraform_remote_state.vpc_dev.outputs.private_subnets
}