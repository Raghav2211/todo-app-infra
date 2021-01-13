data "aws_region" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["vpc-${local.name_suffix}"]
  }
}

data "aws_security_groups" "ec2" {
  count = length(local.sg_filters) > 0 ? 1 : 0
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

locals {
  name_suffix    = "${data.aws_region.current.name}-${substr(var.app.env, 0, 1)}-${var.app.id}"
  instance_count = var.instance_count != null && var.instance_count > 0 ? var.instance_count : length(data.aws_subnet_ids.ec2.ids)
  sg_filters = length(var.security_group_filters) > 0 ? concat(var.security_group_filters, [{
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }]) : []
  sg_ids = length(local.sg_filters) == 0 ? [] : data.aws_security_groups.ec2[0].ids
  tags = {
    AppId       = var.app.id
    App         = var.app.name
    Version     = var.app.version
    Role        = var.app.role
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
  user_data                   = var.user_data

  tags = local.tags
}