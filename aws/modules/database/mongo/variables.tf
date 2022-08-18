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

variable "master_password" {
  description = "Password for the master DB user."
  type        = string
}

variable "master_username" {
  type        = string
  description = "Username for the master DB user."
}


variable "subnet_ids" {
  description = "List of subnet IDs database instances should deploy into."
  type        = list(string)
}

variable "instance_type" {
  type        = string
  default     = "db.t3.medium"
  description = "The instance class to use"
}

variable "cluster_size" {
  type        = string
  default     = "2"
  description = "Number of DB instances to create in the cluster"
}

variable "tls_enabled" {
  type        = bool
  default     = false
  description = "When true than cluster using TLS for communication."
}

variable "security_group_ids" {
  type        = list(string)
  description = "security groups to associate with the cluster"
}