variable "app" {
  type = object(
    {
      id      = string
      version = string
      env     = string
    }
  )
}

variable region {}

variable "cidr" {}

variable "azs" {}

variable "public_subnets" {}

variable "private_subnets" {}

variable "enable_ssh" {
  type        = bool
  description = "Whether to enable ssh on worker nodes via bastion"
  default     = false
}

variable "worker_conf" {
  type = list(object({
    name                 = string
    instance_type        = string
    asg_min_size         = number
    asg_max_size         = number
    asg_desired_capacity = number
  }))
  description = "Worker(s) configuration"
}