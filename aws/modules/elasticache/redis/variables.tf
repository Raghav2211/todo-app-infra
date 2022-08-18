variable "app" {
  type = object(
    {
      environment = string # dev, uat
      account     = string # lab, prd
      region      = string
      team        = string
      name        = string
    }
  )
}

variable "subnet_ids" {
  description = "List of subnet IDs database instances should deploy into."
  type        = list(string)
}

variable "instance_type" {
  type    = string
  default = "cache.m5.xlarge"
}

variable "port" {
  type    = number
  default = 6379
}
variable "engine_version" {
  type    = string
  default = "6.x"
}

variable "shard_count" {
  type    = number
  default = 1
}

variable "replica_count" {
  type    = number
  default = 1
}

variable "security_group_ids" {
  type        = list(string)
  description = "security groups to associate with the cluster"
}