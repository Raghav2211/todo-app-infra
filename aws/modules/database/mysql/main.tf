data "aws_region" "current" {}

locals {
  database_subnet_group = var.subnet_group != "" ? var.subnet_group : var.app.environment
  tags = {
    account     = var.app.account
    project     = "mysql"
    environment = var.app.environment
    application = "database"
    team        = var.app.team
  }
}

module "mysql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "4.4.0"

  identifier = "mysql-${var.app.environment}-${var.app.name}"

  engine            = "mysql"
  engine_version    = "8.0.21"
  instance_class    = var.instance_type
  allocated_storage = var.storage_size_in_gib
  storage_encrypted = false
  #storage_type = var.storage_type

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  db_name  = var.app.name
  username = var.master_user
  password = var.master_password
  port     = "3306"

  vpc_security_group_ids = var.security_group_ids
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
  availability_zone     = var.availability_zone
  multi_az              = var.multi_az
  max_allocated_storage = var.max_allocated_storage
}