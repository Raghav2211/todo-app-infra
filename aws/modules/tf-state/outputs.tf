output "tf_state_bucket_arn" {
  value = module.tf_state_bucket.s3_bucket_arn
}

output "tf_state_lock_table_id" {
  value = aws_dynamodb_table.tf_state_lock.id
}
