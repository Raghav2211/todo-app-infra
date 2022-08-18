#variable "region" {}

variable "app" {
  default = {
    environment = "dev"
    account     = "lab"
    region      = "us-east-2"
  }
}

variable "cidr" {
  default = "172.31.0.0/24"
}

variable "azs" {
  default = ["us-east-2a", "us-east-2b"]
}

variable "public_subnets" {
  default = ["172.31.0.128/26", "172.31.0.192/26"]
}

variable "private_subnets" {
  default = ["172.31.0.0/27", "172.31.0.32/27"]
}

variable "database_subnets" {
  default = ["172.31.0.64/27", "172.31.0.96/27"]
}