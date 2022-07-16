variable "app" {
  default = {
    environment = "dev"
    account     = "lab"
    team        = "todo"
    name        = "test"
  }
}

variable "master_username" {
  default = "admin1"
}

variable "master_password" {
  default = "password"
}

variable "mongo_description" {
  default = "Mongo security group"
}
