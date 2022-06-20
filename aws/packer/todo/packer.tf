terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.18.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "= 3.1.1"
    }
  }
  required_version = "= 1.2.2"
}

data "aws_region" "current" {}

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

variable "app_version" {
  default = "1.0.0"
}

locals {
  ami_name = join("-", ["todo-app-${var.app_version}-amd64-hvm-ebs", formatdate("YYYYMMDDhhmmss", timestamp())])
}

resource "null_resource" "todo_packer" {
  triggers = {
    ami_name = local.ami_name
  }
  provisioner "local-exec" {
    command = <<EOF
                  packer build \
                    -var 'region=${data.aws_region.current.name}' \
                    -var 'vpc=${data.terraform_remote_state.vpc_dev.outputs.id}' \
                    -var 'subnet=${data.terraform_remote_state.vpc_dev.outputs.public_subnets[0]}' \
                    -var 'ami_name=${local.ami_name}' \
                    -var 'app_version=${var.app_version}' \
                    app.json || {
                      printf "\n Failed \n" >&2
                      exit 1
                    }
              EOF
  }
}