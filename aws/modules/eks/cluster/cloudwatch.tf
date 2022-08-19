resource "aws_cloudwatch_log_group" "eks_cluster_log_group" {
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = 90
  tags              = local.tags
}

resource "aws_iam_role_policy" "eks_cluster_cloudwatch_inline_policy" {
  name = "cloudwatch policy"
  role = data.aws_iam_role.cluster_iam_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["logs:CreateLogGroup"]
        Effect   = "Deny"
        Resource = aws_cloudwatch_log_group.eks_cluster_log_group.arn
      },
    ]
  })
}