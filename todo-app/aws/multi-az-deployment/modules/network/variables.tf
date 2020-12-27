variable "name" {
  description = "Name to be used on all the resources as identifier"
}

variable "env" {
  description = "Environment identifier"
}

variable "cidr" {
  description = "The CIDR block for the VPC"
}

# variable "azs" {
#   description = "A list of availability zones in the region"
#   type        = "list"
#   default     = []
# }

# variable "public_subnets" {
#   description = "A list of public subnets inside the VPC"
#   type        = "list"
#   default     = []
# }