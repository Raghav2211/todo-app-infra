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


variable "instance_type" {
  type        = string
  description = "App instance type"
}

# auto-scaling group & launch configuration
variable "image_id" {
  type        = string
  description = "Application AMI id"
  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}



variable "scaling_capacity" {
  type        = map(string)
  description = "Scaling paramter for EC2 Auto scaling group"
  default = {
    min     = 1
    desired = 2
    max     = 3
  }
}

variable "app_installer_tpl_path" {
  type        = string
  description = "File path to use app deployment"
}

variable "app_env_vars" {
  type        = map
  default     = {}
  description = "App deployment environment variables"
}
variable "target_group_arns"{
  type      = list(string)
  default   = []
  description  = "Alb target group arns"
}