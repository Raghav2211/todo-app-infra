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

variable "instance_type" {}

variable "master_user" {}

variable "master_password" {}

variable "multi_az" {}

variable "storage_size_in_gib" {}

variable "database_name" {}