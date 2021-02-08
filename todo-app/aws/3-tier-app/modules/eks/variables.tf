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