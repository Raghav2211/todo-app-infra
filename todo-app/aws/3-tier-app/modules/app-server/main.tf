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
    values = ["security-group-${local.name_suffix}-${var.app.name}-lb"]
  }
}

data "aws_subnet_ids" "public_subnets" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Tier"
    values = ["public"]
  }
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

  name = "alb-${local.name_suffix}-${var.app.name}"

  vpc_id          = data.aws_vpc.selected.id
  subnets         = data.aws_subnet_ids.public_subnets.ids
  security_groups = list(data.aws_security_group.selected.id)

  access_logs = {
    bucket = "my-alb-logs"
  }

  target_groups = [
    {
      name             = "tg-${local.name_suffix}-${var.app.name}"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "instance"
      health_check = {
        enabled             = true
        healthy_threshold   = 2
        unhealthy_threshold = 2
        interval            = 120
        timeout             = 5
      }
      tags = {
        App = "tg-http-8080-${var.app.name}"
      }
    }
  ]

  # https_listeners = [
  #   {
  #     port               = 443
  #     protocol           = "HTTPS"
  #     certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
  #     target_group_index = 0
  #   }
  # ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = merge(local.tags, {
    App = "alb"
  })

  target_group_tags = {
    App = "tg-${var.app.name}"
  }
}