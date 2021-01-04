provider "aws" {
  region = var.region
}

data "aws_region" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["vpc-${local.name_suffix}"]
  }
}

data "aws_security_group" "selected" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "group-name"
    values = ["security-group-${local.name_suffix}-bastion"]
  }
}

data "aws_subnet_ids" "public_subnets" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Tier"
    values = ["public"]
  }
}

data "aws_ami" "ubuntu" {
  count       = var.ami == "" ? 1 : 0
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "lab_user_ssh_data" {
  template = file("${path.module}/userdata/user.tpl")
  count    = length(var.ssh_users)
  vars = {
    username   = var.ssh_users[count.index]["username"]
    public_key = var.ssh_users[count.index]["public_key"]
  }
}

locals {
  name_suffix = "${data.aws_region.current.name}-${substr(var.app.env, 0, 1)}-${var.app.id}"
  ami         = var.ami != "" ? var.ami : data.aws_ami.ubuntu[0].image_id
  tags = {
    AppId       = var.app.id
    App         = "bastion"
    Version     = var.app.version
    Role        = "infra"
    Environment = var.app.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}

module "ec2_bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.16.0"

  name           = "ec2-${local.name_suffix}-bastion"
  instance_count = length(data.aws_subnet_ids.public_subnets.ids)

  ami           = local.ami
  instance_type = var.instance_type
  #monitoring             = true
  vpc_security_group_ids      = list(data.aws_security_group.selected.id)
  subnet_ids                  = data.aws_subnet_ids.public_subnets.ids
  associate_public_ip_address = true
  user_data                   = join("\n", data.template_file.lab_user_ssh_data.*.rendered)

  tags = local.tags
}