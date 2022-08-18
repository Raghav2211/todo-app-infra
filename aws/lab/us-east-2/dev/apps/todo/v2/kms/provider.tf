terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.18.0"
    }
  }
  backend "s3" {
    bucket         = "todo-tf-state-lab"
    key            = "lab/us-east-2/dev/todo/kms.tf"
    region         = "us-east-2"
    encrypt        = true
    kms_key_id     = "alias/todo-tf-state-key"
    dynamodb_table = "todo-tf-state-lab"
  }
  required_version = "= 1.2.2"
}