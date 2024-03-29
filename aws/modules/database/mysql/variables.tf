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

variable "vpc_id" {
  type = string
}
variable "instance_type" {
  description = "RDS(Mysql) instance type"
  type        = string
}

variable "storage_size_in_gib" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 5
}

variable "database_name" {
  type    = string
  default = ""
}

variable "create_database_name_as_appid" {
  description = "Specifies if data base name is same as appid"
  type        = bool
  default     = true
}

variable "master_user" {
  type        = string
  description = "Mysql master user"
}

variable "master_password" {
  type        = string
  description = "Mysql master password"
  validation {
    condition     = length(var.master_password) >= 8
    error_message = "Master password should not be of length less than 8 charactors."
  }
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_group" {
  default     = ""
  description = "Database subnet group, if not provided it'll use default subnet group"
}


variable "availability_zone" {
  description = "The Availability Zone of the RDS instance"
  type        = string
  default     = ""
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 30
}