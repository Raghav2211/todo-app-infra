locals {

  node_group_iam_role_name = "${var.app.account}-${var.app.environment}-eks-node-group-role"

  self_managed_node_groups = [
    {
      name                         = "node_group_01"
      platform                     = "bottlerocket"
      instance_type                = "m5.large"
      ami_id                       = data.aws_ami.eks_default_bottlerocket.id
      asg_min_size                 = 1
      asg_desired_capacity         = 2
      asg_max_size                 = 3
      key_name                     = aws_key_pair.this.key_name
      bootstrap_extra_args         = <<-EOT
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
      iam_role_name                = local.node_group_iam_role_name
      iam_role_additional_policies = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
    }
  ]
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "aws_key_pair" "this" {
  key_name   = "${var.app.account}-${var.app.environment}-eks-key"
  public_key = tls_private_key.this.public_key_openssh
}