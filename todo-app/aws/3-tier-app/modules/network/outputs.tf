output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}


output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

output "igw_id" {
  description = "Internet gateway id"
  value       = module.vpc.igw_id
}

output "database_subnet_group" {
  description = "Database subnet group id"
  value       = module.vpc.database_subnet_group
}

output "natgw_ids" {
  description = "List of IDs of Nat gateway"
  value       = module.vpc.natgw_ids
}