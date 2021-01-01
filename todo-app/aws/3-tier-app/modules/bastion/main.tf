data "aws_region" "current" {}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_ami" "ubuntu" {
count       = var.ami == "" ? 1 : 0
most_recent = true
owners = ["099720109477"] # Canonical

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
  vars = {
    username = "user"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+bITpNqlrx/bkrPrMGtg3pEk9ZAAzANdu/u9oGXELR+HkqVlyvdTl60meDcdj6SSTkAbg+AlIsrSjonK12wz+5JJ1EbZkItPYOWSI6whoF4oxH6J672Hjr275IjpAdbR81BYA1oYrpYXb8M9S92Z/0/yyXjrpnURYZZ1SyD7er6ziXRgsHGZu4DnBFvxhBUzjfuqxJEDQvTiwGLESubN0yFHCgntKIuontti1lxFpMi/dHON8Ov7xTmcj7WzxAM3eZzN1w8kI3wVh0HIv0SBfi1zUwkPgDbiDjgKwAZqRQTVJS2+ZAU72STtNPMWY5htTx1zpWX5xBpHUsSfriqIt raghav@rspls-MacBook-Pro.local"
  }
}

locals {
  name_suffix = "${data.aws_region.current.name}-${substr(var.app.env,0,1)}-${var.app.id}${var.app.name}${var.app.suffix != "" ? "-${var.app.suffix}" : ""}"
  ami                    = var.ami != "" ? var.ami : data.aws_ami.ubuntu[0].image_id
}

module "sg_ssh" {
  source                 = "terraform-aws-modules/security-group/aws//modules/ssh"
  version                = "3.17.0"
  name                   = "security-group-${local.name_suffix}"  
  vpc_id                 = var.vpc_id
  description            = var.description
  ingress_cidr_blocks    = concat(var.ingress_cidr, ["${chomp(data.http.myip.body)}/32"])
  use_name_prefix        = false
  auto_ingress_with_self = []

  tags = {
    AppId       = var.app.id
    App         = var.app.name
    Version     = var.app.version
    Role        = "infra"
    Environment = var.app.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}

module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "2.16.0"

  name                   = "ec2-${local.name_suffix}"
  instance_count         = length(var.public_subnets)

  ami                    = local.ami
  instance_type          = var.instance_type
  #monitoring             = true
  vpc_security_group_ids = list(module.sg_ssh.this_security_group_id)
  subnet_ids              = var.public_subnets
  associate_public_ip_address = true
  user_data            = data.template_file.lab_user_ssh_data.rendered


  tags = {
    AppId       = var.app.id
    App         = var.app.name
    Version     = var.app.version
    Role        = "infra"
    Environment = var.app.env
    #Time        = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}