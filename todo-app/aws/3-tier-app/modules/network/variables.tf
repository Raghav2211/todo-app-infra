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

variable "bastion_description" {
  type        = string
  description = "Bastion security group"
  default     = "Bastion security group"
}

variable "bastion_ingress_cidrs" {
  type        = list
  description = "Ingress CIDR(s) blocks for the bastion security group"
  default     = []
}
variable "ami" {
  type        = string
  description = "The AMI to use for the instance. By default it is the AMI provided by Amazon with Ubuntu 20.04"
  default     = ""
  # validation {
  #   condition     = can(regex("^ami-", var.ami))
  #   error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  # }
}

variable "instance_type" {
  type        = string
  description = "Type of instance, Default is t2.micro"
  default     = "t2.micro"
}
# Validation on admin as user
variable "bastion_ssh_users" {
  type        = list(map(string))
  description = "Bastion host ssh user details"
  validation {
    condition     = length(var.bastion_ssh_users) >= 1
    error_message = "Atleast one bastion cluster ssh user needs to be passed."
  }
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


variable "bastion_instance_count" {
  type    = number
  default = null
}

variable "associate_public_ip_address" {
  description = "Enable public IP address on ec2 instance(s)"
  type        = bool
  default     = false
}

variable "security_group_filters" {
  description = "Security group filters to find security groups for ec2 instance(s)"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []
}

variable "subnet_filters" {
  description = "Subnet filters to find subnet for ec2 instance(s)"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []
}

variable "user_data" {
  description = "The user data to provide when launching the instance."
  type        = string
  default     = null
}
