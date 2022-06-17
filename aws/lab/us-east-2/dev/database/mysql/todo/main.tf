module "mysql" {
  source             = "../../../../../../modules/database/mysql"
  app                = var.app
  vpc_id             = data.terraform_remote_state.vpc_dev.outputs.id
  instance_type      = var.instance_type
  master_user        = var.master_user
  master_password    = var.master_password
  multi_az           = var.multi_az
  security_group_ids = tolist([module.mysql_sg.this_security_group_id])
}