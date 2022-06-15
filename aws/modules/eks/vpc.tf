module "vpc" {
  source                       = "../network/"
  app                          = var.app
  cidr                         = var.cidr
  azs                          = var.azs
  public_subnets               = var.public_subnets
  private_subnets              = var.private_subnets
  enable_nat_gateway_single    = true
  create_database_subnet_group = false
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}