resource "aws_kms_key" "eks" {
  description              = "EKS Secret Encryption Key"
  policy                   = data.aws_iam_policy_document.eks.json
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
  deletion_window_in_days  = 7
  tags                     = local.tags
}

resource "aws_kms_alias" "eks" {
  name          = "alias/${var.app.account}-${var.app.environment}-eks"
  target_key_id = aws_kms_key.eks.key_id
}

data "aws_iam_policy_document" "eks" {
  statement {
    sid       = "All access to root user"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.app.id}:root"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_encryption" {
  policy_arn = aws_iam_policy.eks_cluster_encryption.arn
  role       = data.aws_iam_role.cluster_iam_role.name
}

resource "aws_iam_policy" "eks_cluster_encryption" {
  name        = "${data.aws_iam_role.cluster_iam_role.name}-ClusterEncryption"
  description = "eks cluster ${local.cluster_name} encryption policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ListGrants",
          "kms:DescribeKey",
        ]
        Effect   = "Allow"
        Resource = aws_kms_key.eks.arn
      },
    ]
  })
  tags = local.tags
}