terraform {

  backend "s3" {
    bucket         = "todo-tf-state-lab"
    key            = "lab/global/route53.tf"
    region         = "us-east-2"
    encrypt        = true
    kms_key_id     = "alias/todo-tf-state-key"
    dynamodb_table = "todo-tf-state-lab"
  }
  required_version = "= 1.2.2"
}