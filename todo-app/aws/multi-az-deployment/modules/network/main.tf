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
  reuse_nat_ips =true                          # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = aws_eip.nat.*.id       # <= IPs specified here as input to the module


  tags = {
    App         = var.name
    Environment = var.env
  }

}

resource "aws_eip" "nat" {
  count = length(var.azs)
  vpc = true
}
