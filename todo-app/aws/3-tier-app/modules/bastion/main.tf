data "aws_region" "current" {}

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
  sg_filters = [
    {
      name   = "group-name"
      values = ["security-group-${local.name_suffix}-bastion"]
    },
  ]
  subnet_filters = [
    {
      name   = "tag:Tier"
      values = ["public"]
    },
  ]
}

module "ec2_bastion" {
  source                      = "../ec2"
  app                         = merge(var.app, { name = "bastion" })
  ami                         = local.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  security_group_filters      = local.sg_filters
  subnet_filters              = local.subnet_filters
  user_data                   = join("\n", data.template_file.lab_user_ssh_data.*.rendered)
}