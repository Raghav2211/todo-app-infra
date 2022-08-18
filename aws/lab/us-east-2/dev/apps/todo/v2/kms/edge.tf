locals {
  edge_tags = merge({ application = "edge" }, var.default_tags)
}

resource "aws_kms_key" "edge" {
  description              = "Encrypt/Decrypt AWS edge config values"
  policy                   = data.aws_iam_policy_document.edge.json
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
  tags                     = local.edge_tags
}

resource "aws_kms_alias" "edge" {
  name          = "alias/${var.app.account}-${var.app.environment}-edge"
  target_key_id = aws_kms_key.edge.key_id
}

data "aws_iam_policy_document" "edge" {
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