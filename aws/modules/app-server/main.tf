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


# App
data "aws_security_group" "app" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "group-name"
    values = ["security-group-${local.name_suffix}-${var.app.name}-app"]
  }
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
  source                 = "../asg/"
  app                    = var.app
  app_installer_tpl_path = var.app_installer_tpl_path
  app_env_vars=var.app_env_vars
  # Launch configuration
  image_id      = var.image_id
  instance_type = var.instance_type
  # Auto scaling group
  target_group_arns         = module.alb.target_group_arns
}