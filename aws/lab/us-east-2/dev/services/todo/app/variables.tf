variable "app" {
  default = {
    environment = "dev"
    account     = "lab"
  }
}

variable "instance_type" {
  default = "t2.medium"
}

variable "app_env_vars" {}

variable "account_id" {}

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