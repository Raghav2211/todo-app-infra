variable "app" {
  type = object(
    {
      id      = string
      name    = string
      role    = string
      version = string
      env     = string
    }
  )
}

variable "ami" {
  type        = string
  description = "The AMI to use for the instance. By default it is the AMI provided by Amazon with Ubuntu 20.04"
  validation {
    condition     = can(regex("^ami-", var.ami))
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "instance_type" {
  type        = string
  description = "Type of instance, Default is t2.micro."
  default     = "t2.micro"
}

variable "instance_count" {
  type    = number
  default = 0
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