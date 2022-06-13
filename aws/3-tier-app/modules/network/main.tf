data "aws_region" "current" {}


locals {
  name_suffix                   = "${data.aws_region.current.name}-${substr(var.app.env, 0, 1)}-${var.app.id}"
  enable_nat_gateway_per_subnet = var.enable_nat_gateway_per_subnet || var.enable_nat_gateway_single || var.enable_nat_gateway_per_az
  single_nat_gateway            = local.enable_nat_gateway_per_subnet && var.enable_nat_gateway_single
  enable_nat_gateway_per_az     = local.enable_nat_gateway_per_subnet && (var.enable_nat_gateway_per_az && var.enable_nat_gateway_single ? ! var.enable_nat_gateway_per_az : var.enable_nat_gateway_per_az)
  database_subnet_group         = var.create_database_subnet_group ? length(var.database_subnets) > 1 : ! var.create_database_subnet_group
  public_subnets_size           = length(var.public_subnets)
  tags = {
    AppId       = var.app.id
    Version     = var.app.version
    Role        = "network"
    Environment = var.app.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}

module "vpc" {
  source                             = "terraform-aws-modules/vpc/aws"
  version                            = "2.64.0"
  name                               = "vpc-${local.name_suffix}"
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

  public_subnet_tags = merge(var.public_subnet_tags, {
    Tier = "public"
  })

  private_subnet_tags = merge(var.private_subnet_tags, {
    Tier = "private"
  })

  database_subnet_tags = {
    Tier = "db"
  }

  igw_tags = {
    Name = "igw-${local.name_suffix}"
  }

  public_route_table_tags = {
    Name = "rtb-${local.name_suffix}-public"
  }

  private_route_table_tags = {
    Name = "rtb-${local.name_suffix}-private"
  }

  database_route_table_tags = {
    Name = "rtb-${local.name_suffix}-db"
  }

  database_subnet_group_tags = {
    Name = "default-subnet-grp-${local.name_suffix}"
  }
}