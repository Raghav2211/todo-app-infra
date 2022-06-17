variable "app" {
  default = {
    environment = "dev"
    account     = "lab"
    team        = "todo"
    name        = "test"
  }
}

variable "instance_type" {
  default = "db.m5.large"
}

variable "master_user" {}

variable "master_password" {}

variable "multi_az" {
  default = false
}

variable "mysql_description" {
  default = "RDS security group"
}