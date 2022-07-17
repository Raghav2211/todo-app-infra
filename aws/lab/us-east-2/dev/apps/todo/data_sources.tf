data "terraform_remote_state" "vpc_dev" {
  backend = "s3"

  config = {
    bucket         = "todo-tf-state-lab"
    key            = "network/vpc.tf"
    region         = "us-east-2"
    encrypt        = true
    kms_key_id     = "alias/todo-tf-state-key"
    dynamodb_table = "todo-tf-state-lab"
  }
}

data "aws_ami" "app" {
  most_recent = true
  owners      = [var.account_id] # Canonical
  filter {
    name   = "tag:Name"
    values = ["TodoApp"]
  }

  filter {
    name   = "tag:OS_Version"
    values = ["Ubuntu"]
  }

  filter {
    name   = "tag:Release"
    values = [var.app.version]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

}