data "aws_region" "current" {}

## create bucket for lab account

locals {
  name_suffix = "${var.app.account}-${var.app.environment}"

}


module "tf_state_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.2.4"

  bucket = "tf-state-${local.name_suffix}"
  acl    = "private"

  versioning = {
    enabled = true
  }

}

resource "aws_dynamodb_table" "tf_state_lock" {
  name           = "tf-state-${local.name_suffix}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}