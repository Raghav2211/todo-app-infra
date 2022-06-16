provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "../../"
  app = {
    environment = "test"
    account     = "lab"
  }
  cidr                         = "172.31.0.0/24"
  azs                          = ["us-west-2a", "us-west-2b"]
  public_subnets               = ["172.31.0.128/26", "172.31.0.192/26"]
  private_subnets              = ["172.31.0.0/27", "172.31.0.32/27"]
  database_subnets             = ["172.31.0.64/27", "172.31.0.96/27"]
  create_internet_gateway      = true
  create_database_subnet_group = true
  enable_nat_gateway_single    = true
} 