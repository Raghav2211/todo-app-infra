variable "app" {
  default = {
    environment = "dev"
    account     = "lab"
  }
}

variable "todo_lb_description" {
  default = "Todo App LoadBalancer security group"
}

variable "todo_app_description" {
  default = "Todo App security group"
}

variable "mysql_description" {
  default = "RDS security group"
}

variable "env_cidr_block" {
  type        = bool
  description = "Add current deployment enviornment cidr block"
  default     = true
}

variable "todo_app_lb_ingress_cidrs" {
  type        = list(any)
  description = "Ingress CIDR(s) blocks for the bastion security group, Default is all [0.0.0.0/0]"
  default     = ["0.0.0.0/0"]
}

variable "todo_app_lb_https_ingress" {
  type    = bool
  default = true
}