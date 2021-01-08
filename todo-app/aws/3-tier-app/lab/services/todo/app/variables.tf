variable "region" {}

variable "app" {
  type = object(
    {
      id      = string
      name    = string
      version = string
      env     = string
    }
  )
}

variable "image_id" {}

variable "instance_type" {}


variable "app_env_vars" {}