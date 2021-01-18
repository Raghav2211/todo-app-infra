output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "database_subnet_group" {
  value = module.vpc.database_subnet_group
}

output "natgw_ids" {
  value = module.vpc.natgw_ids
}