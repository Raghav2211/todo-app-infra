resource "aws_iam_policy" "edge_service_config_decrypt_iam_policy" {
  name        = "EdgeServiceConfigDecryptPolicy"
  path        = "/"
  description = "Policy to decrypt edge-service config"
  policy      = data.aws_iam_policy_document.edge_service_config_decrypt_iam_policy_document.json
  tags        = local.edge_tags
}

data "aws_iam_policy_document" "edge_service_config_decrypt_iam_policy_document" {
  statement {
    sid = "DecryptEdgeServiceConfig"

    actions = [
      "kms:Decrypt"
    ]
    resources = [aws_kms_key.edge.arn]
  }
}


resource "aws_iam_role_policy_attachment" "edge_service_config_decrypt_iam_role_policy_attachment" {
  role       = "lab-dev-eks-node-group-role"
  policy_arn = aws_iam_policy.edge_service_config_decrypt_iam_policy.arn
}