module "todo_app_ecr" {
  source = "../../../../../../../modules/ecr"
  app = {
    environment = "dev"
    account     = "lab"
    region      = "us-east-2"
    project     = "todo"
    application = "todo-app"
    team        = "todo"
  }
  repo_name         = "apps/todo-app"
  keep_no_of_images = 10
}

module "edge_service_ecr" {
  source = "../../../../../../../modules/ecr"
  app = {
    environment = "dev"
    account     = "lab"
    region      = "us-east-2"
    project     = "todo"
    application = "edge-service"
    team        = "todo"
  }
  repo_name         = "apps/edge-service"
  keep_no_of_images = 10
}

module "config_server_ecr" {
  source = "../../../../../../../modules/ecr"
  app = {
    environment = "dev"
    account     = "lab"
    region      = "us-east-2"
    project     = "todo"
    application = "config-server"
    team        = "todo"
  }
  repo_name         = "apps/config-server"
  keep_no_of_images = 10
}