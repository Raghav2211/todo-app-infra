data "terraform_remote_state" "vpc_dev" {
  backend = "s3"

  config = {
    region         = "us-east-2"
    bucket         = "todo-state-lab"
    key            = "network/vpc.tf"
    dynamodb_table = "terraform-state-lock"
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