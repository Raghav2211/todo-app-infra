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
}

variable "master_password" {
  type = string
}

variable "subnet_group" {
  default     = ""
  description = "Database subnet group"
}