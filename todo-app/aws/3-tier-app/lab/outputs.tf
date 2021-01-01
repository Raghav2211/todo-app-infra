# output "vpc_id" {
#   value = module.vpc.vpc_id
# }

output "public_subnets" {
  value = module.vpc.public_subnets
}

# # output "bastion_sg_id" {
# #   description = "The ID of the bastion security group"
# #   value       = module.sg_ssh.this_security_group_id
# # }

# output "az" {
#   value = data.aws_availability_zones.available
# }

# output "localstate" {
#   value = data.terraform_remote_state.vpc
# }