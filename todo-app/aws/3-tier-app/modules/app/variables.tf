variable "app" {
  type = object(
    {
      id      = string
      name    = string
      version = string
      env     = string
    }
  )
}

variable "description" {
  type        = string
  description = "Bastion security group"
  default     = "Bastion security group"
}

variable "vpc_id" {
  type        = string
  description = "ID of vpc where bastion resource(s) will create"
}

variable "ingress_cidrs" {
  type        = list
  description = "Ingress CIDR(s) blocks for the bastion security group, Default is all [0.0.0.0/0]"
  default     = ["0.0.0.0/0"]
}

variable "http443enable" {
  type        = bool
  description = "Whether to enable https"
  default     = true
}