data "aws_region" "current" {}

locals {
  tags = {
    account     = var.app.account
    project     = "mongo"
    environment = var.app.environment
    application = "database"
    team        = var.app.team
  }
}

resource "aws_docdb_cluster" "this" {
  cluster_identifier              = "mongo-${var.app.environment}-${var.app.name}"
  master_username                 = var.master_username
  master_password                 = var.master_password
  skip_final_snapshot             = true
  apply_immediately               = true
  vpc_security_group_ids          = var.security_group_ids
  db_subnet_group_name            = aws_docdb_subnet_group.this.name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.this.name
  engine                          = "docdb"
  engine_version                  = "4.0.0"
  tags                            = local.tags
}

resource "aws_docdb_cluster_instance" "this" {
  count              = var.cluster_size
  identifier         = "mongo-${var.app.environment}-${var.app.name}-${count.index}"
  cluster_identifier = join("", aws_docdb_cluster.this.*.id)
  instance_class     = var.instance_type
  tags               = local.tags
}

resource "aws_docdb_subnet_group" "this" {
  name        = "sg-${var.app.environment}-${var.app.name}"
  description = "Allowed subnets for DB cluster instances."
  subnet_ids  = var.subnet_ids
  tags        = local.tags
}

resource "aws_docdb_cluster_parameter_group" "this" {
  name        = "pg-${var.app.environment}-${var.app.name}"
  description = "DB cluster parameter group."
  family      = "docdb4.0"
  parameter {
    name  = "tls"
    value = var.tls_enabled ? "enabled" : "disabled"
  }
  tags = local.tags
}
