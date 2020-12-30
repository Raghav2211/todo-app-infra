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
}

variable "ingress_cidr" {
  type        = list
  description = "Ingress CIDR blocks for the security group"
}

variable "http443enable" {
  type        = bool
  description = "Whether to enable https with http/80"
  default     = true
}