data "aws_region" "current" {}

locals {
  name_suffix   = "${data.aws_region.current.name}-${substr(var.app.env, 0, 1)}-${var.app.id}${var.app.name}-mysql"
  database_name = var.database_name != "" ? var.database_name : var.app.name
  tags = {
    AppId       = var.app.id
    App         = var.app.name
    Version     = var.app.version
    Role        = "infra"
    Environment = var.app.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}

module "sg_mysql" {
  source                 = "terraform-aws-modules/security-group/aws//modules/mysql"
  version                = "3.17.0"
  name                   = "security-group-${local.name_suffix}"
  vpc_id                 = var.vpc_id
  description            = var.description
  use_name_prefix        = false
  auto_ingress_with_self = []
  auto_ingress_rules     = []
  computed_ingress_with_source_security_group_id = [for app_sg_id in var.app_sg_ids :
    {
      rule                     = "mysql-tcp"
      source_security_group_id = app_sg_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  tags = local.tags
}

module "db_mysql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.20.0"

  identifier = "db-${local.name_suffix}"

  engine            = "mysql"
  engine_version    = "8.0.21"
  instance_class    = var.instance_type
  allocated_storage = var.storage_size_in_gib
  storage_encrypted = false
  #storage_type = var.storage_type

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  name     = local.database_name
  username = var.master_user
  password = var.master_password
  port     = var.port

  vpc_security_group_ids = list(module.sg_mysql.this_security_group_id)
  create_db_subnet_group = false
  db_subnet_group_name   = local.name_suffix

  multi_az = false

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

}