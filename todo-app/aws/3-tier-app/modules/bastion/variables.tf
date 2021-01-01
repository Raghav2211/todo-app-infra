variable "app" {
  type = object(
    {
      id      = string
      name    = string
      version = string
      env     = string
    }
  )
}

variable "description" {
  type        = string
  description = "Bastion security group"
  default     = "Bastion security group"
}

variable "vpc_id" {
  type        = string
  description = "ID of vpc where bastion resource(s) will create"
}
variable "public_subnets" {
  type        = list
  description = "List of VPC Subnet IDs to launch bastion host"
}

variable "ingress_cidrs" {
  type        = list
  description = "Ingress CIDR(s) blocks for the bastion security group"
  default     = []
}

variable "env_cidr_block" {
  type        = bool
  description = "Add current deployment enviornment cidr block"
  default     = true
}

variable "ami" {
  type        = string
  description = "The AMI to use for the instance. By default it is the AMI provided by Amazon with Ubuntu 20.04"
  default     = ""
}

variable "instance_type" {
  type        = string
  description = "Type of instance, Default is t2.micro"
  default     = "t2.micro"
}

variable "ssh_users" {
  type        = list(map(string))
  description = "Bastion host ssh user details"
  default     = []
}