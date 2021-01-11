variable "app" {
  type = object(
    {
      id      = string
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
  description = "Type of instance, Default is t2.micro"
  default     = "t2.micro"
}


variable "security_group_filters" {
  type    = list(map(string))
  default = []
}

# Validation on admin as user
variable "ssh_users" {
  type        = list(map(string))
  description = "Bastion host ssh user details"
  validation {
    condition     = length(var.ssh_users) >= 1
    error_message = "Atleast one bastion cluster ssh user needs to be passed."
  }
}