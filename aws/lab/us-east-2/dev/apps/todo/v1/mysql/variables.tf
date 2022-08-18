variable "app" {
  default = {
    environment = "dev"
    account     = "lab"
    region      = "us-east-2"
    team        = "todo"
    name        = "test"
  }
}

variable "instance_type" {
  default = "db.m5.large"
}

variable "master_user" {
  default = "admin" //TODO: integrate this with aws secret manager
}

variable "master_password" {
  default = "admin123" // TODO: integrate this with aws secret manager
}

variable "multi_az" {
  default = false
}

variable "mysql_description" {
  default = "RDS security group"
}