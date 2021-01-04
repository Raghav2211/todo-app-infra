variable "region" {}

variable "app" {
  type = object(
    {
      id      = string
      version = string
      env     = string
    }
  )
}

# rds(mysql) varaibles
variable "instance_type" {
  type    = string
  default = "db.t2.micro"
}

variable "storage_size_in_gib" {
  type    = number
  default = 5
}

variable "database_name" {
  type    = string
  default = ""
}

variable "master_user" {
  type = string
  #sensitive = true
}

variable "master_password" {
  type = string
  #sensitive = true
}
variable "port" {
  type    = string
  default = "3306"
}

variable "subnet_group" {
  default = ""
  description = "Database subnet group"
}