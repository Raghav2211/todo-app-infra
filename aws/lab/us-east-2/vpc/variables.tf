#variable "region" {}

variable "app" {
  type = object(
    {
      id      = string
      version = string
      env     = string
    }
  )
}

variable "cidr" {}

variable "azs" {}

variable "public_subnets" {}

variable "private_subnets" {}

variable "database_subnets" {}