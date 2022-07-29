locals {
  tags = {
    account     = var.app.account
    project     = "redis"
    environment = var.app.environment
    application = "elasticache"
    team        = var.app.team
  }
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id          = "redis-${var.app.environment}-${var.app.name}"
  replication_group_description = "Terraform-managed ElastiCache replication group for redis-${var.app.environment}-${var.app.name}"
  node_type                     = var.instance_type
  automatic_failover_enabled    = true
  multi_az_enabled              = true
  engine_version                = var.engine_version
  port                          = var.port
  parameter_group_name          = "default.redis6.x.cluster.on"
  subnet_group_name             = aws_elasticache_subnet_group.this.id
  security_group_ids            = var.security_group_ids
  apply_immediately             = false
  maintenance_window            = "sun:22:30-sun:23:30"
  snapshot_retention_limit      = "0"

  cluster_mode {
    replicas_per_node_group = var.replica_count
    num_node_groups         = var.shard_count
  }

  tags = local.tags
}
resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.app.environment}-${var.app.name}"
  subnet_ids = var.subnet_ids
  tags       = local.tags
}


