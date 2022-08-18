module "dev_mongo" {
  source             = "../../../../../../../modules/database/mongo"
  app                = var.app
  master_username    = var.master_username
  master_password    = var.master_password
  subnet_ids         = data.terraform_remote_state.vpc_dev.outputs.database_subnets
  security_group_ids = tolist([module.mongo_sg.this_security_group_id])
}