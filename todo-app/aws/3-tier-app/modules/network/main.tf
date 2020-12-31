# Declare the data source
data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  enable_nat_gateway_per_subnet = var.enable_nat_gateway_per_subnet || var.enable_nat_gateway_single || var.enable_nat_gateway_per_az
  single_nat_gateway = var.enable_nat_gateway_per_subnet ? false : var.enable_nat_gateway_single
  enable_nat_gateway_per_az = var.enable_nat_gateway_per_subnet ? false : ( var.enable_nat_gateway_per_az && var.enable_nat_gateway_single ? !var.enable_nat_gateway_per_az : var.enable_nat_gateway_per_az )
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  name = "vpc-${data.aws_region.current.name}-${substr(var.app.env,0,1)}-${var.app.id}${var.app.name}"
  cidr = var.cidr
  azs  = var.azs

  # subnets
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  # gateways
  enable_nat_gateway     = local.enable_nat_gateway_per_subnet
  single_nat_gateway     = local.single_nat_gateway
  one_nat_gateway_per_az = local.enable_nat_gateway_per_az

  # database
  create_database_subnet_group       = length(var.database_subnets) > 1 
  create_database_subnet_route_table = length(var.database_subnets) > 1 


  tags = {
    AppId       = var.app.id
    App         = var.app.name
    Version     = var.app.version
    Role        = "infra"
    Environment = var.app.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }

}