data "aws_region" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["vpc-${local.name_suffix}"]
  }
}

# App
data "aws_security_group" "app" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "group-name"
    values = ["security-group-${local.name_suffix}-${var.app.name}-app"]
  }
}

data "aws_security_group" "selected" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "group-name"
    values = ["security-group-${local.name_suffix}-${var.app.name}-app-lb"]
  }
}
data "template_file" "app_data" {
  template = file(var.app_installer_tpl_path)
  vars     = var.app_env_vars
}
data "aws_subnet_ids" "private_subnets" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Tier"
    values = ["private"]
  }
}
locals {
  name_suffix = "${data.aws_region.current.name}-${substr(var.app.env, 0, 1)}-${var.app.id}"
  tags = {
    AppId       = var.app.id
    App         = var.app.name
    Version     = var.app.version
    Role        = "app"
    Environment = var.app.env
    LastScanned = formatdate("YYYYMMDDhh", timestamp())
  }
  scaling_capacity = var.scaling_capacity
}
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "3.8.0"

  name = "ec2-${local.name_suffix}-${var.app.name}-app"

  # Launch configuration
  lc_name         = "lc-${local.name_suffix}-${var.app.name}-app"
  image_id        = var.image_id
  instance_type   = var.instance_type
  security_groups = list(data.aws_security_group.app.id)
  user_data       = data.template_file.app_data.rendered

  # Auto scaling group
  asg_name                  = "asg-${local.name_suffix}-${var.app.name}-app"
  vpc_zone_identifier       = data.aws_subnet_ids.private_subnets.ids
  health_check_type         = "EC2"
  min_size                  = lookup(local.scaling_capacity, "min")
  max_size                  = lookup(local.scaling_capacity, "max")
  desired_capacity          = lookup(local.scaling_capacity, "desired")
  wait_for_capacity_timeout = 0
  tags_as_map               = local.tags
}