variable "app_id" {
  description = "Application identifier"
  default = "psi"
}

variable "app_name" {
  description = "Application Name"
}

variable "app_version" {
  description = "Application Version"
}

variable "env" {
  description = "Environment identifier"
}

variable "cidr" {
  description = "The CIDR block for the VPC"
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = list
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list
  default     = []
}

variable "database_subnets" {
  description = "A list of database subnets"
  type        = list
  default     = []
}