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

variable "instance_type" {}

variable "app_env_vars" {}

variable "account_id" {}
variable "image_id" {}
variable "scaling_capacity" {}