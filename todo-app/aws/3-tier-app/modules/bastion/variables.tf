variable "app" {
  type = object(
    {
      id      = string
      name    = string
      version = string
      env     = string
      suffix  = string
    }
  )
}

variable "description" {
  type        = string
  description = "Bastion host security group"
  default = "Bastion host security group"
}

variable "ingress_cidr" {
  type        = list
  description = "Ingress CIDR blocks for the security group"
  default     = []
}