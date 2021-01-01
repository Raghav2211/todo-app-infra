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
  type = string
}
variable "public_subnets" {
  type = list
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

variable "ami" {
  type = string
  default = ""
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}