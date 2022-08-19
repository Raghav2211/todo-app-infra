data "aws_partition" "current" {}

locals {
  tags = {
    account     = var.app.account
    project     = "infra"
    application = "eks"
    team        = "sre"
  }
}

################################################
#   IAM ROLE for self managed node groups      #
################################################
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid     = "EKSNodeAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "eks_node_group_iam_role" {
  name                  = var.node_group_iam_role_name
  description           = "eks ${var.app.account} self managed node group IAM role"
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
  force_detach_policies = true
  tags                  = local.tags
}

resource "aws_iam_instance_profile" "eks_node_group_profile" {
  role = aws_iam_role.eks_node_group_iam_role.name
  name = var.node_group_iam_role_name
  lifecycle {
    create_before_destroy = true
  }
  tags = local.tags
}

################################################
#   IAM ROLE for eks cluster                   #
################################################
data "aws_iam_policy_document" "assume_role_policy" {

  statement {
    sid     = "EKSClusterAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "cluster_iam_role" {
  name                  = var.cluster_iam_role_name
  description           = "eks ${var.app.account} cluster IAM role"
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
  force_detach_policies = true
  tags                  = local.tags
}



