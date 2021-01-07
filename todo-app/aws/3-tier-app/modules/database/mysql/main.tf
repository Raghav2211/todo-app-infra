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
    values = ["security-group-${local.name_suffix}-${local.app_name}"]
  }
}

locals {
  app_name              = "mysql"
  name_suffix           = "${data.aws_region.current.name}-${substr(var.app.env, 0, 1)}-${var.app.id}"
  database_name         = var.database_name != "" ? var.database_name : var.create_database_name_as_appid ? var.app.id : null
  database_subnet_group = var.subnet_group != "" ? var.subnet_group : "vpc-${local.name_suffix}"
  tags = {
    AppId       = var.app.id
    App         = local.app_name
    Version     = var.app.version
    Role        = "db"
    Environment = var.app.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}

module "mysql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.20.0"

  identifier = "rds-${local.name_suffix}-${local.app_name}"

  engine            = local.app_name
  engine_version    = "8.0.21"
  instance_class    = var.instance_type
  allocated_storage = var.storage_size_in_gib
  storage_encrypted = false
  #storage_type = var.storage_type

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  name     = local.database_name
  username = var.master_user
  password = var.master_password
  port     = "3306"

  vpc_security_group_ids = list(data.aws_security_group.selected.id)
  create_db_subnet_group = false
  db_subnet_group_name   = local.database_subnet_group


  # disable backups to create DB faster
  backup_retention_period = 0

  tags = local.tags

  enabled_cloudwatch_logs_exports = ["general", "error"]


  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_protection = false

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  
  # DB instance creation
  availability_zone           = var.availability_zone
  multi_az                    = var.multi_az
  max_allocated_storage       = var.max_allocated_storage
}