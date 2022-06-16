data "terraform_remote_state" "vpc_dev" {
  backend = "s3"

  config = {
    region         = "us-east-2"
    bucket         = "todo-state-lab"
    key            = "network/vpc.tf"
    dynamodb_table = "terraform-state-lock"
  }
}