variable "app" {
  type = object(
    {
      environment = string # dev, uat
      account     = string # lab, prd
    }
  )
}

variable "cluster_id" {
  type        = string
  description = "EKS cluster id"
}

variable "cluster_endpoint" {
  type        = string
  description = "EKS cluster endpoint"
}

variable "cluster_certificate_authority_data" {
  type        = string
  description = "EKS cluster certificate"
}

variable "hosted_zones_name" { type = list(string) }

variable "hosted_zones_ids" { type = list(string) }

variable "oidc_provider_arn" { type = string }