variable "app" {
  type = object(
    {
      environment = string # dev, uat
      account     = string # lab, prd
    }
  )
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "additional_cluster_tags" {
  type    = map(string)
  default = {}
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

variable "self_managed_node_groups" {
  type = any
}