variable "app" {
  default = {
    environment = "dev"
    account     = "lab"
    region      = "us-east-2"
    name        = "todo"
    version     = "1.0.0"
  }
}

variable "instance_type" {
  default = "t2.medium"
}

variable "app_env_vars" {
  default = {
    MYSQL_HOST     = "mysql-dev-test.************.us-east-2.rds.amazonaws.com:3306" # TODO: use rds data source to get MYSQL_HOST
    MYSQL_DB_NAME  = "test"
    MYSQL_USER     = "admin"
    MYSQL_PASSWORD = "admin123" # TODO: use aws secret manager to get username & password
  }
}

variable "account_id" {
  #default = "123456789" # TODO: this should be replace by actual account
}

variable "todo_lb_description" {
  default = "Todo App LoadBalancer security group"
}

variable "todo_app_description" {
  default = "Todo App security group"
}

variable "todo_app_lb_ingress_cidrs" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}