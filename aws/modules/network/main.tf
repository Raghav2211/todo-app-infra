data "aws_region" "current" {}


locals {
  enable_nat_gateway_per_subnet = var.enable_nat_gateway_per_subnet || var.enable_nat_gateway_single || var.enable_nat_gateway_per_az
  single_nat_gateway            = local.enable_nat_gateway_per_subnet && var.enable_nat_gateway_single
  enable_nat_gateway_per_az     = local.enable_nat_gateway_per_subnet && (var.enable_nat_gateway_per_az && var.enable_nat_gateway_single ? !var.enable_nat_gateway_per_az : var.enable_nat_gateway_per_az)
  database_subnet_group         = var.create_database_subnet_group ? length(var.database_subnets) > 1 : !var.create_database_subnet_group
  public_subnets_size           = length(var.public_subnets)
  tags = {
    account     = var.app.account
    project     = "infra"
    environment = var.app.environment
    application = "vpc"
    team        = "sre"
  }
}

module "vpc" {
  source                             = "terraform-aws-modules/vpc/aws"
  version                            = "2.64.0"
  name                               = var.app.environment
  cidr                               = var.cidr
  azs                                = var.azs
  public_subnets                     = var.public_subnets
  private_subnets                    = var.private_subnets
  database_subnets                   = var.database_subnets
  create_igw                         = var.create_internet_gateway
  enable_nat_gateway                 = local.enable_nat_gateway_per_subnet
  single_nat_gateway                 = local.single_nat_gateway
  one_nat_gateway_per_az             = local.enable_nat_gateway_per_az
  create_database_subnet_group       = local.database_subnet_group
  create_database_subnet_route_table = length(var.database_subnets) > 1
  instance_tenancy                   = var.instance_tenancy
  tags = merge(local.tags, {
    module = "vpc"
  })

  public_subnet_tags = merge(var.public_subnet_tags, {
    tier   = "public"
    module = "subnet"
  })

  private_subnet_tags = merge(var.private_subnet_tags, {
    tier   = "private"
    module = "subnet"
  })

  database_subnet_tags = {
    tier   = "db"
    module = "subnet"
  }

  igw_tags = {
    Name   = "igw-${var.app.environment}"
    module = "internet-gateway"
  }

  public_route_table_tags = {
    Name   = "rtb-${var.app.environment}-public"
    module = "route-table"
  }

  private_route_table_tags = {
    Name   = "rtb-${var.app.environment}-private"
    module = "route-table"
  }

  database_route_table_tags = {
    Name   = "rtb-${var.app.environment}-db"
    module = "route-table"
  }

  database_subnet_group_tags = {
    Name   = "default-subnet-grp-${var.app.environment}"
    module = "subnet-group"
  }
}