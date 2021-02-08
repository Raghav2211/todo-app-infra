data "aws_region" "current" {}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_security_group" "worker_ssh" {
  count = var.enable_ssh ? 1 : 0
  name  = "security-group-${local.name_suffix}-bastion"
}

locals {
  name_suffix                  = "${data.aws_region.current.name}-${substr(var.app.env, 0, 1)}-${var.app.id}"
  cluster_name                 = "eks-${local.name_suffix}"
  worker_ssh_security_group_id = var.enable_ssh ? data.aws_security_group.worker_ssh[0].id : []
  worker_security_group_ids    = concat(local.worker_ssh_security_group_id)

  tags = {
    AppId       = var.app.id
    Version     = var.app.version
    Role        = "infra"
    Environment = var.app.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "13.2.1"
  cluster_name    = local.cluster_name
  cluster_version = "1.17"
  subnets         = module.vpc.private_subnets
  tags            = local.tags
  vpc_id          = module.vpc.vpc_id
  worker_groups = [
    {
      name                 = "worker-group-1"
      instance_type        = "t2.small"
      additional_userdata  = "echo foo bar"
      asg_desired_capacity = 2
      //      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
  ]
  worker_additional_security_group_ids = local.worker_security_group_ids
  write_kubeconfig                     = false
  #map_roles                            = var.map_roles
  #map_users                            = var.map_users
  #map_accounts                         = var.map_accounts

}
