terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.18.0"
    }
  }
  required_version = "= 1.2.2"
}

data "aws_region" "current" {}

## create bucket for lab account

resource "aws_s3_bucket" "terraform_state" {
  bucket = "todo-state-lab"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-state-lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}