variable "region" {}

variable "app" {
  type = object(
    {
      id      = string
      version = string
      env     = string
    }
  )
}

variable "todo_lb_description" {
  type        = string
  description = "Todo App LoadBalancer security group"
  default     = "Todo App LoadBalancer security group"
}

variable "todo_app_description" {
  type        = string
  description = "Todo App security group"
  default     = "Todo App security group"
}

variable "mysql_description" {
  type        = string
  description = "Secuity group description"
  default     = "RDS security group"
}

variable "bastion_ingress_cidrs" {
  type        = list
  description = "Ingress CIDR(s) blocks for the bastion security group"
  default     = []
}

variable "env_cidr_block" {
  type        = bool
  description = "Add current deployment enviornment cidr block"
  default     = true
}

variable "todo_app_lb_ingress_cidrs" {
  type        = list
  description = "Ingress CIDR(s) blocks for the bastion security group, Default is all [0.0.0.0/0]"
  default     = ["0.0.0.0/0"]
}

variable "todo_app_lb_https_ingress" {
  type        = bool
  description = "Whether to enable https"
  default     = true
}
variable "enable_todo_app_ssh" {
  type        = bool
  description = "Whether to enable ssh for todo app"
  default     = false
}