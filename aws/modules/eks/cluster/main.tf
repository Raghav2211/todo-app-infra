module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.24.0"

  cluster_name                    = local.cluster_name
  cluster_version                 = local.k8s_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  #cluster_service_ipv4_cidr       = data.aws_vpc.selected.cidr_block # TODO : change CIDR block for service layer of k8s as per user requirement
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids # should be private

  # cluster addons
  cluster_addons = {
    coredns = {
      addon_version     = "v1.8.0-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      addon_version     = "v1.19.6-eksbuild.2"
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      addon_version     = "v1.11.2-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    }
  }
  # Configuration block with encryption configuration for the cluster
  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]

  # cluster IAM configuration
  create_iam_role = false
  iam_role_arn    = data.aws_iam_role.cluster_iam_role.arn

  # Self managed node groups will not automatically create the aws-auth configmap so we need to
  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  # Extend cluster security group configuration
  cluster_security_group_name            = "${var.app.account}-${var.app.environment}-eks-cluster-sg"
  cluster_security_group_use_name_prefix = false
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }
  cluster_security_group_tags = local.tags


  # Extend node-to-node security group configuration
  node_security_group_name            = "${var.app.account}-${var.app.environment}-eks-node-sg"
  node_security_group_use_name_prefix = false
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
  node_security_group_tags = local.tags

  self_managed_node_group_defaults = {
    create_security_group = false

    # enable discovery of autoscaling groups by cluster-autoscaler
    autoscaling_group_tags = {
      "k8s.io/cluster-autoscaler/enabled" : true,
      "k8s.io/cluster-autoscaler/${local.cluster_name}" : "owned",
    }
  }
  self_managed_node_groups = local.self_managed_node_groups
  cluster_tags             = var.additional_cluster_tags
  tags                     = local.tags
}


