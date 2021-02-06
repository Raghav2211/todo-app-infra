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
variable "image_id" {}

variable "instance_type" {}


variable "scaling_capacity" {}

variable "app_installer_tpl_path" {}

variable "app_env_vars" {}