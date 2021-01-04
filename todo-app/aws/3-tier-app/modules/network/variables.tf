variable "app" {
  type = object(
    {
      id      = string
      version = string
      env     = string
    }
  )
}

variable "cidr" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
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

variable "create_database_subnet_group" {
  description = "Whether database subnet group is created"
  type        = bool
  default     = false
}

variable "enable_nat_gateway_per_subnet" {
  type        = bool
  description = "Enable Nat Gateway per subnet"
  default     = false
}

variable "enable_nat_gateway_single" {
  type        = bool
  description = "Enable single Nat Gateway"
  default     = false
}

variable "enable_nat_gateway_per_az" {
  type        = bool
  description = "Enable Nat Gateway per availability zone"
  default     = false
}
