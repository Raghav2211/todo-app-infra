variable "region" {
  default = "us-west-2"
}

variable "name" {
  default = "todo"
}

variable "cidr" {
  default = "172.31.0.0/24"
}

variable "azs" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "private_subnets" {
  default = ["172.31.0.64/27", "172.31.0.96/27"]
}

variable "public_subnets" {
  default = ["172.31.0.128/26", "172.31.0.192/26"]
}

variable "intra_subnets" {
  default = ["172.31.0.0/27", "172.31.0.32/27"]
}
