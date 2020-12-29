data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

module "bastion_ssh" {
  source      = "../modules/sg"
  app_name    = var.app_name
  app_version = var.app_version
  env         = var.env
  # add bastion suffix
  #name                = "${var.app_name}-${var.env}-bastion"
  vpc_id       = module.vpc.vpc_id
  description  = "Bastion host security group"
  ingress_cidr = concat(var.sg_bastion_cidrs, ["${chomp(data.http.myip.body)}/32"])

}