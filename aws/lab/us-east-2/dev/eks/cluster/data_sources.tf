data "terraform_remote_state" "vpc_dev" {
  backend = "s3"

  config = {
    bucket         = "todo-tf-state-lab"
    key            = "lab/us-east-2/dev/network/vpc.tf"
    region         = "us-east-2"
    encrypt        = true
    kms_key_id     = "alias/todo-tf-state-key"
    dynamodb_table = "todo-tf-state-lab"
  }
}

data "aws_ami" "eks_default_bottlerocket" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["bottlerocket-aws-k8s-${module.dev_eks.k8s_version}-x86_64-*"]
  }
}