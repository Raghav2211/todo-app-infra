resource "aws_iam_policy" "todo_app_config_decrypt_iam_policy" {
  name        = "TodoAppConfigDecryptPolicy"
  path        = "/"
  description = "Policy to decrypt todo app config"
  policy      = data.aws_iam_policy_document.todo_app_config_decrypt_iam_policy_document.json
  tags        = local.todo_app_tags
}

data "aws_iam_policy_document" "todo_app_config_decrypt_iam_policy_document" {
  statement {
    sid = "DecryptTodoAppConfig"

    actions = [
      "kms:Decrypt"
    ]
    resources = [aws_kms_key.todo_app.arn]
  }
}


resource "aws_iam_role_policy_attachment" "todo_app_config_decrypt_iam_role_policy_attachment" {
  role       = "lab-dev-eks-node-group-role"
  policy_arn = aws_iam_policy.todo_app_config_decrypt_iam_policy.arn
}