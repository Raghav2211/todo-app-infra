locals {
  tags = merge(var.tags, {
    account     = var.app.account
    project     = "infra"
    environment = var.app.environment
    application = "eks"
    team        = "sre"
  })
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.24.0"

  cluster_name                    = var.app.environment
  cluster_version                 = var.k8s_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  #cluster_service_ipv4_cidr       = data.aws_vpc.selected.cidr_block # TODO : change CIDR block for service layer of k8s as per user requirement
  vpc_id     = var.vpc_id
  subnet_ids = var.nodegroup_subnet_ids # should be private
  cluster_addons = {
    coredns = {
      addon_version     = "v1.8.0-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }
  # Configuration block with encryption configuration for the cluster
  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]



  # Self managed node groups will not automatically create the aws-auth configmap so we need to
  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  # Extend cluster security group rules
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

  # Extend node-to-node security group rules
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
      "k8s.io/cluster-autoscaler/${var.app.environment}" : "owned",
    }
  }

  self_managed_node_groups = {

    # Bottlerocket node group
    bottlerocket = {
      name = "bottlerocket-self-mng"

      platform      = "bottlerocket"
      ami_id        = data.aws_ami.eks_default_bottlerocket.id
      instance_type = "m5.large"
      desired_size  = 2
      key_name      = aws_key_pair.this.key_name

      iam_role_additional_policies = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

      bootstrap_extra_args = <<-EOT
      # The admin host container provides SSH access and runs with "superpowers".
      # It is disabled by default, but can be disabled explicitly.
      [settings.host-containers.admin]
      enabled = false

      # The control host container provides out-of-band access via SSM.
      # It is enabled by default, and can be disabled if you do not expect to use SSM.
      # This could leave you with no way to access the API and change settings on an existing node!
      [settings.host-containers.control]
      enabled = true

      [settings.kubernetes.node-labels]
      ingress = "allowed"
      EOT
    }
  }
  cluster_tags = var.additional_cluster_tags
  tags         = local.tags
}

module "external_dns" {
  source            = "./external-dns"
  count             = var.external_dns.create ? 1 : 0
  environment       = var.app.environment
  aws_region        = data.aws_region.current.name
  domain_filters    = var.external_dns.domain_filters
  oidc_provider_arn = module.eks.oidc_provider_arn
  tags              = local.tags
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "aws_key_pair" "this" {
  key_name   = var.app.environment
  public_key = tls_private_key.this.public_key_openssh
}

resource "aws_ec2_capacity_reservation" "targeted" {
  instance_type           = "m6i.large"
  instance_platform       = "Linux/UNIX"
  availability_zone       = "${data.aws_region.current.name}a"
  instance_count          = 1
  instance_match_criteria = "targeted"
}

