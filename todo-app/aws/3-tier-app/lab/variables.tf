variable "region" {}

variable "app_id" {
  default = "psi"
}

variable "app_name" {
  default = "todo"
}

variable "app_version" {
  default = "1.0.0"
}

variable "env" {
  description = "Envionment"
}

variable "cidr" {}

variable "azs" {}

variable "public_subnets" {}

variable "private_subnets" {}

variable "database_subnets" {}

variable "sg_bastion_ingress_cidrs" {
  default = []

}

variable "sg_loadbalancer_ingress_cidrs" {
  default = []
}

