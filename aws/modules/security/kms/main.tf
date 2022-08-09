module "kms" {
  source = "terraform-aws-modules/kms/aws"

  enable_key_rotation     = true
  key_usage = "ENCRYPT_DECRYPT"

  description = "EC2 AutoScaling key usage"
  key_usage   = "ENCRYPT_DECRYPT"

  # Policy
  key_administrators = ["arn:aws:iam::012345678901:role/admin"]
  key_users          = ["arn:aws:iam::012345678901:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
  key_service_users  = ["arn:aws:iam::012345678901:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]

  # Aliases
  aliases = ["eks/edge"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}