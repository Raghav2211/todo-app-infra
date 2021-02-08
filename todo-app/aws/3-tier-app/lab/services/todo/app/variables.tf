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
variable "app_installer_tpl_path" {}
variable "image_id" {}
variable "scaling_capacity" {}