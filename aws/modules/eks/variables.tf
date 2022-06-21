variable "app" {
  type = object(
    {
      environment = string # dev, uat
      account     = string # lab, prd
    }
  )
}

variable "region" {}

variable "cidr" {}

variable "azs" {}

variable "public_subnets" {}

variable "private_subnets" {}

variable "k8s_version" {
  type        = string
  description = "K8s version for eks cluster"
  default     = "1.19"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

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