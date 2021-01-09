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
    values = ["security-group-${local.name_suffix}-${var.app.name}-app-lb"]
  }
}

data "aws_security_group" "app" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "group-name"
    values = ["security-group-${local.name_suffix}-${var.app.name}-app"]
  }
}

data "aws_subnet_ids" "public_subnets" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Tier"
    values = ["public"]
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

data "aws_instances" "app" {
  instance_tags = {
    AppName     = var.app.name
    Version     = var.app.version
    Environment = var.app.env
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  instance_state_names = ["running", "pending"]
}

locals {
  name_suffix = "${data.aws_region.current.name}-${substr(var.app.env, 0, 1)}-${var.app.id}"
  tags = {
    AppId       = var.app.id
    AppName     = var.app.name
    Version     = var.app.version
    Role        = "app"
    Environment = var.app.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.10.0"

  name = "alb-${local.name_suffix}-${var.app.name}-app"

  vpc_id          = data.aws_vpc.selected.id
  subnets         = data.aws_subnet_ids.public_subnets.ids
  security_groups = list(data.aws_security_group.selected.id)

  target_groups = [
    {
      name                          = "tg-${local.name_suffix}-${var.app.name}-app"
      backend_protocol              = "HTTP"
      backend_port                  = var.app_port
      target_type                   = "instance"
      load_balancing_algorithm_type = var.load_balance_algo
      health_check = {
        enabled             = lookup(var.app_health, "enabled", true)
        path                = lookup(var.app_health, "path", "/")
        healthy_threshold   = lookup(var.app_health, "healthy_threshold", 2)
        unhealthy_threshold = lookup(var.app_health, "unhealthy_threshold", 2)
        interval            = lookup(var.app_health, "interval", 120)
        timeout             = lookup(var.app_health, "timeout", 5)
      }
      tags = {
        App = "tg-http-${var.app_port}-${var.app.name}-app"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = var.http_listener_port
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = merge(local.tags, {
    App = "alb"
  })
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "3.8.0"

  name = "ec2-${local.name_suffix}-${var.app.name}-app"

  # Launch configuration
  lc_name = "lc-${local.name_suffix}-${var.app.name}-app"

  image_id        = var.image_id
  instance_type   = var.instance_type
  security_groups = list(data.aws_security_group.app.id)
  user_data       = data.template_file.app_data.rendered



  # Auto scaling group
  asg_name                  = "asg-${local.name_suffix}-${var.app.name}-app"
  vpc_zone_identifier       = data.aws_subnet_ids.private_subnets.ids
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  target_group_arns         = module.alb.target_group_arns

  tags_as_map = local.tags
}

resource "aws_alb_target_group_attachment" "app" {
  count            = length(data.aws_instances.app.ids)
  target_group_arn = module.alb.target_group_arns[0]
  target_id        = data.aws_instances.app.ids[count.index]
}