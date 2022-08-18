locals {
  todo_app_tags = merge({ application = "todo" }, var.default_tags)
}
resource "aws_kms_key" "todo_app" {
  description              = "Encrypt/Decrypt AWS todo app config values"
  policy                   = data.aws_iam_policy_document.todo_app.json
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
  tags                     = local.todo_app_tags
}

resource "aws_kms_alias" "todo_app" {
  name          = "alias/${var.app.account}-${var.app.environment}-todo-app"
  target_key_id = aws_kms_key.todo_app.key_id
}

data "aws_iam_policy_document" "todo_app" {
  statement {
    sid     = "Enable IAM policies"
    actions = ["kms:*"]
    # In a key policy, the value of the Resource element is "*", which means "this KMS key." The asterisk ("*") identifies the KMS key to which the key policy is attached
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.app.id}:root"]
    }
  }
}