data "aws_region" "current" {}

data "template_file" "app_data" {
  template = file(var.app_installer_tpl_path)
  vars     = var.app_env_vars
}

locals {
  tags = {
    account     = var.app.account
    project     = "infra"
    environment = var.app.environment
    application = "ec2"
    team        = "sre"
  }
}
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "3.8.0"

  name = "${var.app.environment}-${var.app.name}"

  # Launch configuration
  lc_name         = "lc-${var.app.environment}-${var.app.name}"
  image_id        = var.image_id
  instance_type   = var.instance_type
  security_groups = var.security_group_ids
  user_data       = data.template_file.app_data.rendered

  # Auto scaling group
  asg_name                  = "asg-${var.app.environment}-${var.app.name}"
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "EC2"
  min_size                  = lookup(var.scaling_capacity, "min")
  max_size                  = lookup(var.scaling_capacity, "max")
  desired_capacity          = lookup(var.scaling_capacity, "desired")
  wait_for_capacity_timeout = 0
  tags_as_map               = local.tags
  target_group_arns         = var.alb_target_group_arns
}