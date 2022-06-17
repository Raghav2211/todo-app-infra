output "tf_state_bucket_arn" {
  value = module.todo-tf-state-bucket.s3_bucket_arn
}

output "tf_state_lock_table_id" {
  value = aws_dynamodb_table.todo-tf-state-lock.id
}
