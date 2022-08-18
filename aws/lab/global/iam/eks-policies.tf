resource "aws_iam_role_policy_attachment" "eks_node_group_role_policy_attachment" {
  for_each   = toset(var.node_group_role_policies)
  policy_arn = each.value
  role       = aws_iam_role.eks_node_group_role.name
}
