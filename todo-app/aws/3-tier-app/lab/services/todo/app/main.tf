# Provider configuration
provider "aws" {
  region = var.region
}
data "aws_ami" "app" {
  most_recent = true
  owners      = [var.account_id] # Canonical
  filter {
    name   = "tag:Name"
    values = ["TodoApp"]
  }

  filter {
    name   = "tag:OS_Version"
    values = ["Ubuntu"]
  }

  filter {
    name   = "tag:Release"
    values = [var.app.version]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

}


module "todo_app" {
  source                 = "../../../../modules/app-server"
  app                    = var.app
  image_id               = data.aws_ami.app.image_id
  instance_type          = var.instance_type
  app_installer_tpl_path = "${path.module}/templates/deployment.tpl"
  app_env_vars           = var.app_env_vars
  scaling_capacity       = var.scaling_capacity
  app_health = {
    path = "/actuator/health"
  }
}