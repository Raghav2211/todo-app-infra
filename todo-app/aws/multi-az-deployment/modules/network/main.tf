module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  name = "${var.app_name}-${var.env}"
  cidr = var.cidr
  azs  = var.azs

  # subnets
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  # gateways
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  # database
  create_database_subnet_group       = true
  create_database_subnet_route_table = true


  tags = {
    AppId       = var.app_id
    App         = var.app_name
    Version     = var.app_version
    Role        = "infra"
    Environment = var.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }

}