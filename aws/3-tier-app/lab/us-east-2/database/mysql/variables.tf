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