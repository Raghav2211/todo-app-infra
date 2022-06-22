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
variable "public_subnet_ids" {
  type = list(string)
}

variable "nodegroup_subnet_ids" {
  type = list(string)
}

variable "k8s_version" {
  type        = string
  description = "K8s version for eks cluster"
  default     = "1.19"
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