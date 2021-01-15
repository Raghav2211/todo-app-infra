module "todo_app" {
  source                 = "../../../../modules/app-server"
  app                    = var.app
  image_id               = var.image_id
  instance_type          = var.instance_type
  app_installer_tpl_path = "${path.module}/templates/deployment.tpl"
  app_env_vars           = var.app_env_vars
  app_health = {
    path = "/actuator/health"
  }
}