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

variable "app_port" {
  type        = number
  description = "Port on which application will listen"
  default     = 8080
}

variable "http_listener_port" {
  type        = number
  description = "Load balancer listener port"
  default     = 80
}

variable "load_balance_algo" {
  description = "Load balancing algorithm | Value is round_robin or least_outstanding_requests"
  type        = string
  default     = "round_robin"
}

variable "app_health" {
  type        = map
  description = "Application Health check configuration"
  default     = {}
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

variable "instance_type" {
  type        = string
  description = "App instance type"
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
  description = "App deployment enviornment variables"
}