module "todo_app_alb" {
  source             = "../../../../../../modules/alb"
  app                = var.app
  vpc_id             = data.terraform_remote_state.vpc_dev.outputs.id
  security_group_ids = [module.todo_app_load_balancer_sg.this_security_group_id]
  subnet_ids         = data.terraform_remote_state.vpc_dev.outputs.public_subnets
  app_health = {
    path = "/actuator/health"
  }
}

module "todo_app_asg" {
  source                 = "../../../../../../modules/asg"
  app                    = var.app
  security_group_ids     = [module.todo_app_sg.this_security_group_id]
  subnet_ids             = data.terraform_remote_state.vpc_dev.outputs.private_subnets
  image_id               = data.aws_ami.app.image_id
  instance_type          = var.instance_type
  app_installer_tpl_path = "${path.module}/templates/deployment.tpl"
  app_env_vars           = var.app_env_vars
  alb_target_group_arns  = module.todo_app_alb.target_group_arns
}