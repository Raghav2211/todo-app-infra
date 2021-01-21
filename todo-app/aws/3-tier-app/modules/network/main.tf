# Declare the data source
data "aws_region" "current" {}

data "http" "myip" {
  count = var.env_cidr_block ? 1 : 0
  url   = "http://ipv4.icanhazip.com"
}

data "aws_ami" "ubuntu" {
  count       = var.ami == "" ? 1 : 0
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "lab_user_ssh_data" {
  template = file("${path.module}/userdata/user.tpl")
  count    = length(var.ssh_users)
  vars = {
    username   = var.ssh_users[count.index]["username"]
    public_key = var.ssh_users[count.index]["public_key"]
  }
}


locals {
  name_suffix                   = "${data.aws_region.current.name}-${substr(var.app.env, 0, 1)}-${var.app.id}"
  enable_nat_gateway_per_subnet = var.enable_nat_gateway_per_subnet || var.enable_nat_gateway_single || var.enable_nat_gateway_per_az
  single_nat_gateway            = local.enable_nat_gateway_per_subnet && var.enable_nat_gateway_single
  enable_nat_gateway_per_az     = local.enable_nat_gateway_per_subnet && (var.enable_nat_gateway_per_az && var.enable_nat_gateway_single ? ! var.enable_nat_gateway_per_az : var.enable_nat_gateway_per_az)
  database_subnet_group         = var.create_database_subnet_group ? length(var.database_subnets) > 1 : ! var.create_database_subnet_group
  ami         = var.ami != "" ? var.ami : data.aws_ami.ubuntu[0].image_id
  instance_count = var.instance_count != null && var.instance_count > 0 ? var.instance_count : length(module.vpc.public_subnets)
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

  public_subnet_tags = {
    Tier = "public"
  }

  private_subnet_tags = {
    Tier = "private"
  }

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
module "sg_bastion" {
  source                 = "terraform-aws-modules/security-group/aws//modules/ssh"
  version                = "3.17.0"
  name                   = "security-group-${local.name_suffix}-bastion"
  vpc_id                 = module.vpc.vpc_id
  description            = var.bastion_description
  ingress_cidr_blocks    = concat(var.bastion_ingress_cidrs, var.env_cidr_block ? ["${chomp(data.http.myip[0].body)}/32"] : [])
  use_name_prefix        = false
  auto_ingress_with_self = []

  tags = merge(local.tags, {
    App = "bastion"
  })
}
module "ec2_bastion" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "2.16.0"
  name                        = "ec2-${local.name_suffix}-bastion"
  instance_count              = local.instance_count
  ami                         = local.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = list(module.sg_bastion.this_security_group_id)
  subnet_ids                  = module.vpc.public_subnets
  associate_public_ip_address = true
  user_data                   = join("\n", data.template_file.lab_user_ssh_data.*.rendered)
  tags = local.tags
}