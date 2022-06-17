variable "app" {
  type = object(
    {
      environment = string # dev, uat
      account     = string # lab, prd
      name        = string
    }
  )
}
variable "vpc_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}
variable "subnet_ids" {
  type = list(string)
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
  type        = map(any)
  description = "Application Health check configuration"
  default     = {}
}