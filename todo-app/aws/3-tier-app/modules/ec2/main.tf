data "aws_region" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["vpc-${local.name_suffix}"]
  }
}

data "aws_security_groups" "ec2" {
  dynamic "filter" {
    for_each = local.sg_filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}

data "aws_subnet_ids" "ec2" {
  vpc_id = data.aws_vpc.selected.id
  dynamic "filter" {
    for_each = var.subnet_filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
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

# data "template_file" "lab_user_ssh_data" {
#   template = file("${path.module}/userdata/user.tpl")
#   count    = length(var.ssh_users)
#   vars = {
#     username   = var.ssh_users[count.index]["username"]
#     public_key = var.ssh_users[count.index]["public_key"]
#   }
# }

locals {
  name_suffix    = "${data.aws_region.current.name}-${substr(var.app.env, 0, 1)}-${var.app.id}"
  instance_count = var.instance_count != null && var.instance_count > 0 ? var.instance_count : length(data.aws_subnet_ids.ec2.ids)
  sg_filters = length(var.security_group_filters) > 0 ? concat(var.security_group_filters, [{
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }]) : []
  sg_ids = local.sg_filters.length == 0 ? [] : data.aws_security_groups.ec2.ids
  tags = {
    AppId       = var.app.id
    App         = var.app.name
    Version     = var.app.version
    Role        = "infra"
    Environment = var.app.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.16.0"

  name                        = "ec2-${local.name_suffix}-${var.app.name}"
  instance_count              = local.instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = local.sg_ids
  subnet_ids                  = data.aws_subnet_ids.ec2.ids
  associate_public_ip_address = var.associate_public_ip_address
  # user_data                   = join("\n", data.template_file.lab_user_ssh_data.*.rendered)

  tags = local.tags
}