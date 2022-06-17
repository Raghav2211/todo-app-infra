module "todo_app_alb" {
  source = "../../../../../../modules/alb"
  app    = var.app
  #image_id               = data.aws_ami.app.image_id
  #instance_type          = var.instance_type
  vpc_id             = data.terraform_remote_state.vpc_dev.outputs.id
  security_group_ids = [module.todo_app_load_balancer_sg.this_security_group_id]
  subnet_ids         = data.terraform_remote_state.vpc_dev.outputs.public_subnets
  #app_installer_tpl_path = "${path.module}/templates/deployment.tpl"
  #app_env_vars           = var.app_env_vars
  app_health = {
    path = "/actuator/health"
  }
}

#module "todo_app_asg" {
#  source                 = "../../../../../../modules/asg"
#  app                    = var.app
#  image_id               = data.aws_ami.app.image_id
#  instance_type          = var.instance_type
#  app_installer_tpl_path = "${path.module}/templates/deployment.tpl"
#  app_env_vars           = var.app_env_vars
#  app_health = {
#    path = "/actuator/health"
#  }
#}