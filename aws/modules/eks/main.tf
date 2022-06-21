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
  tags = merge(var.tags, {
    account     = var.app.account
    project     = "infra"
    environment = var.app.environment
    application = "eks"
    team        = "sre"
  })
  worker_ssh_security_group_id = var.enable_ssh ? data.aws_security_group.worker_ssh[0].id : []
  worker_security_group_ids    = concat(local.worker_ssh_security_group_id)
  worker_autoscaler_tags = [{
    "key"                 = "k8s.io/cluster-autoscaler/enabled"
    "propagate_at_launch" = "false"
    "value"               = "true"
    },
    {
      "key"                 = "k8s.io/cluster-autoscaler/${var.app.environment}"
      "propagate_at_launch" = "false"
      "value"               = "true"
  }]
  workers = flatten([for i, conf in var.worker_conf : [
    merge(conf,
      {
        tags = concat([for k, v in local.tags :
          {
            "key"                 = k
            "value"               = v
            "propagate_at_launch" = "true"
          }
        ], local.worker_autoscaler_tags)
    })
  ]])
}

module "eks" {
  source                               = "terraform-aws-modules/eks/aws"
  version                              = "18.24.0"
  cluster_name                         = var.app.environment
  cluster_version                      = var.k8s_version
  subnets                              = module.vpc.private_subnets
  tags                                 = local.tags
  vpc_id                               = module.vpc.vpc_id
  worker_groups                        = local.workers
  worker_additional_security_group_ids = local.worker_security_group_ids
  write_kubeconfig                     = false
  #map_roles                            = var.map_roles
  #map_users                            = var.map_users
  #map_accounts                         = var.map_accounts

}
