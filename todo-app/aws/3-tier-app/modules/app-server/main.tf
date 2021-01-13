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

locals {
  name_suffix = "${data.aws_region.current.name}-${substr(var.app.env, 0, 1)}-${var.app.id}"
  app_sg_filters = [
    {
      name   = "group-name"
      values = ["security-group-${local.name_suffix}-${var.app.name}-app"]
    },
  ]
  app_subnet_filters = [
    {
      name   = "tag:Tier"
      values = ["private"]
    },
  ]
  tags = {
    AppId       = var.app.id
    App         = var.app.name
    Version     = var.app.version
    Role        = "app"
    Environment = var.app.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}

module "ec2_app" {
  source                 = "../ec2"
  app                    = merge(var.app, { role = local.tags["Role"] })
  ami                    = var.image_id
  instance_count         = lookup(var.scaling_capacity, "desired")
  instance_type          = var.instance_type
  security_group_filters = local.app_sg_filters
  subnet_filters         = local.app_subnet_filters
  user_data              = data.template_file.app_data.rendered
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
  lc_name         = "lc-${local.name_suffix}-${var.app.name}-app"
  image_id        = var.image_id
  instance_type   = var.instance_type
  security_groups = module.ec2_app.sg_ids
  user_data       = data.template_file.app_data.rendered

  # Auto scaling group
  asg_name                  = "asg-${local.name_suffix}-${var.app.name}-app"
  vpc_zone_identifier       = module.ec2_app.subnets_ids
  health_check_type         = "EC2"
  min_size                  = lookup(var.scaling_capacity, "min")
  max_size                  = lookup(var.scaling_capacity, "max")
  desired_capacity          = lookup(var.scaling_capacity, "desired")
  wait_for_capacity_timeout = 0
  target_group_arns         = module.alb.target_group_arns

  tags_as_map = local.tags
}

resource "aws_alb_target_group_attachment" "app" {
  count            = length(module.ec2_app.ids)
  target_group_arn = module.alb.target_group_arns[0]
  target_id        = module.ec2_app.ids[count.index]
}