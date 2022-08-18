data "aws_region" "current" {}

data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket         = "todo-tf-state-${var.app.account}"
    key            = "${var.app.account}/${data.aws_region.current.name}/${var.app.environment}/eks/${var.app.environment}.tf"
    region         = data.aws_region.current.name
    encrypt        = true
    kms_key_id     = "alias/todo-tf-state-key"
    dynamodb_table = "todo-tf-state-${var.app.account}"
  }
}
