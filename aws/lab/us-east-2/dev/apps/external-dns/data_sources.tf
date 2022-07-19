data "terraform_remote_state" "global_route53" {
  backend = "s3"

  config = {
    bucket         = "todo-tf-state-lab"
    key            = "lab/global/route53.tf"
    region         = "us-east-2"
    encrypt        = true
    kms_key_id     = "alias/todo-tf-state-key"
    dynamodb_table = "todo-tf-state-lab"
  }
}

