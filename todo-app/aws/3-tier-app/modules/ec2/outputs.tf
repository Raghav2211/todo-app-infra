output "ids" {
  value = module.ec2.id
}

output "sg_ids" {
  value = module.ec2.vpc_security_group_ids
}

output "subnets_ids" {
  value = module.ec2.subnet_id
}