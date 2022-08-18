variable "app" {
  type = object(
    {
      environment = string # dev, uat
      account     = string # lab, prd
      region      = string
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
  type        = list(any)
  default     = []
}


variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(any)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(any)
  default     = []
}

variable "database_subnets" {
  description = "A list of database subnets"
  type        = list(any)
  default     = []
}

variable "create_internet_gateway" {
  description = "Whether to enable internet gateway if public subnets is available"
  type        = bool
  default     = true
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

variable "instance_tenancy" {
  description = "Tenancy option for instances launched into the VPC"
  default     = "default"
  validation {
    condition     = contains(["default", "dedicated", "host"], var.instance_tenancy)
    error_message = "Instnace tenancy either default or (dedicated or host)."
  }
}
variable "env_cidr_block" {
  type        = bool
  description = "Add current deployment enviornment cidr block"
  default     = true
}
variable "enable_eks" {
  type        = bool
  description = "Enable eks on vpc so that required tags on public/private subnets could be set"
  default     = false
}
variable "public_subnet_tags" {
  type        = map(string)
  description = "Additional tags for public subnet"
  default     = {}
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Additional tags for private subnet"
  default     = {}
}
