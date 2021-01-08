provider "aws" {
  region = var.region
}

module "todo_app" {
  source        = "../../../../modules/app-server"
  app           = var.app
  image_id      = var.image_id
  instance_type = var.instance_type
  app_variables = var.app_variables
}