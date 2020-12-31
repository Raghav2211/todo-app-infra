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

variable "vpc_id" {
  type        = string
  description = "ID of vpc where security group will create "
}

variable "description" {
  type        = string
  description = "Secuity group description"
  default     = "Mysql security group"
}

variable "ingress_cidr" {
  type        = list
  description = "Ingress CIDR blocks for the security group"
  default     = []
}

variable "ingress_with_sg_id" {
  type = list(map(string))
}