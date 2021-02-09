# Provider configuration
provider "aws" {
  region = var.region
}
module "todo_app" {
  source                 = "../../../../modules/app-server"
  app                    = var.app
  image_id               = "ami-0123456"
  instance_type          = var.instance_type
  app_installer_tpl_path = "${path.module}/templates/deployment.tpl"
  app_env_vars           = var.app_env_vars
  scaling_capacity       = var.scaling_capacity
  app_health = {
    path = "/actuator/health"
  }
}