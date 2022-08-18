output "edge_service_kms_id" {
  value = aws_kms_key.edge.key_id
}

output "edge_service_kms_arn" {
  value = aws_kms_key.edge.arn
}

output "todo_app_kms_id" {
  value = aws_kms_key.todo_app.key_id
}

output "todo_app_kms_arn" {
  value = aws_kms_key.todo_app.arn
}