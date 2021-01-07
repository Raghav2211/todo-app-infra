provider "aws" {
  region = var.region
}
module "mysql" {
  source  = "../../modules/database/mysql"
  app                              = var.app
  instance_type                    = var.instance_type
  storage_size_in_gib              = var.storage_size_in_gib
  database_name                    = var.database_name
  master_user                      = var.master_user
  master_password                  = var.master_password
  multi_az                         = var.multi_az
  
  
}