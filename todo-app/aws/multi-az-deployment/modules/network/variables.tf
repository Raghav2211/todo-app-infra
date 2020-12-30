variable "app" {
  type = object(
    {
      id      = string
      name    = string
      version = string
      env     = string
      suffix  = string
    }
  )
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