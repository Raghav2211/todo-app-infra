provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "../../"
  app = {
    id      = "psi"
    version = "1.0.0"
    env     = "lab"
  }
  cidr                         = "172.31.0.0/24"
  azs                          = ["us-west-2a", "us-west-2b"]
  public_subnets               = ["172.31.0.128/26", "172.31.0.192/26"]
  private_subnets              = ["172.31.0.0/27", "172.31.0.32/27"]
  database_subnets             = ["172.31.0.64/27", "172.31.0.96/27"]
  create_internet_gateway      = true
  create_database_subnet_group = true
  enable_nat_gateway_single    = true
  bastion_ssh_users = [
    {
      username   = "todoapp"
      public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCJrEy5ezxeZ+zF59U+fO0MA6MPamV349kY3acV+Jx2YDcoPcQrGngZg1z6FdqprLfZYDxxoxcEyWc2qhzwYtmUrkqLSTGGooRA2xikWya2FftQrEDglnKNemaTA0//tWP+nq+yrtb1MoRW5QSAMMR6GuOmkNQ+1AYTmr+c4ZXjeXB8/mfaqNaL0E4JEu/wA1uHxuLDsKqkiISc8JS32qwBMK86Cr3i09BQSuPCnE9Fl3ZNEzAcJ2DwoNxGxnyUsUN+7CLrzfzzKRuuJ0rpyC1OSCbO7Yfer0ed6cEF66L1mu7pIo+URf1TXGdq5PySRng0qsWFZgfjxZKqctzcVwV my_email@example.com"
    }
  ]
} 