module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  name = "${var.name}-${var.env}"
  cidr = var.cidr
  azs = var.azs
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
  intra_subnets  = var.intra_subnets
  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  tags = {
    App         = var.name
    Environment = var.env
  }

}

