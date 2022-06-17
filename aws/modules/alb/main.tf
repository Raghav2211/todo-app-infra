data "aws_region" "current" {}

locals {
  tags = {
    account     = var.app.account
    project     = "infra"
    environment = var.app.environment
    application = "ec2"
    team        = "sre"
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.10.0"

  name = "${var.app.environment}-${var.app.name}"

  vpc_id          = var.vpc_id
  subnets         = var.subnet_ids
  security_groups = var.security_group_ids

  target_groups = [
    {
      name                          = "${var.app.environment}-${var.app.name}"
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