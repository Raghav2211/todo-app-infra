locals {
  k8s_version      = 1.19
  cluster_name     = "${var.app.account}-${var.app.environment}-eks"
  cluster_iam_role = "${var.app.account}-eks-cluster-role"

  self_managed_node_groups = {
    for config in var.self_managed_node_groups :
    config.name => {
      name                        = config.name
      platform                    = config.platform
      ami_id                      = config.ami_id
      instance_type               = config.instance_type
      min_size                    = config.asg_min_size
      max_size                    = config.asg_max_size
      desired_size                = config.asg_desired_capacity
      key_name                    = config.key_name
      iam_instance_profile_arn    = data.aws_iam_instance_profile.cluster_iam_instance_prodile.arn
      create_iam_instance_profile = false
      bootstrap_extra_args        = config.bootstrap_extra_args
    }
  }


  tags = merge(var.tags, {
    account     = var.app.account
    project     = "infra"
    environment = var.app.environment
    application = "eks"
    team        = "sre"
  })
}