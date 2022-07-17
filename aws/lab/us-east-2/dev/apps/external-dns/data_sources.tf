data "terraform_remote_state" "eks_dev" {
  backend = "s3"

  config = {
    bucket         = "todo-tf-state-lab"
    key            = "eks/dev.tf"
    region         = "us-east-2"
    encrypt        = true
    kms_key_id     = "alias/todo-tf-state-key"
    dynamodb_table = "todo-tf-state-lab"
  }
}

data "terraform_remote_state" "global_route53" {
  backend = "s3"

  config = {
    bucket         = "todo-tf-state-lab"
    key            = "global/route53.tf"
    region         = "us-east-2"
    encrypt        = true
    kms_key_id     = "alias/todo-tf-state-key"
    dynamodb_table = "todo-tf-state-lab"
  }
}

