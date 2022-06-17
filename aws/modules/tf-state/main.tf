data "aws_region" "current" {}

## create bucket for lab account


module "todo-tf-state-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.2.4"

  bucket = "todo-tf-state-${var.account}"
  acl    = "private"

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.todo-tf-state-key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning = {
    enabled = true
  }

}

resource "aws_dynamodb_table" "todo-tf-state-lock" {
  name           = "todo-tf-state-${var.account}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_kms_key" "todo-tf-state-key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "todo-tf-state-key-alias" {
  name          = "alias/todo-tf-state-key"
  target_key_id = aws_kms_key.todo-tf-state-key.key_id
}