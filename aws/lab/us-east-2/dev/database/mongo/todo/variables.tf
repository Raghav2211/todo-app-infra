variable "app" {
  default = {
    environment = "dev"
    account     = "lab"
    team        = "todo"
    name        = "test"
  }
}

variable "cluster_size" {
  default = 2
}

variable "master_username" {
  default = "admin1"
}

variable "master_password" {
  default = "password"
}

variable "instance_type" {
  default = "db.r4.large"
}
variable "mongo_description" {
  default = "Mongo security group"
}
