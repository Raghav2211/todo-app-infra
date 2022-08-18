module "todo_redis_cluster" {
  source             = "../../../../../../../modules/elasticache//redis"
  app                = var.app
  subnet_ids         = data.terraform_remote_state.vpc_dev.outputs.database_subnets
  security_group_ids = tolist([module.redis_sg.this_security_group_id])
}