output "cluster_arn" {
  value = module.dev_eks.cluster_arn
}

output "cluster_certificate_authority_data" {
  value = module.dev_eks.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  value = module.dev_eks.cluster_endpoint
}

output "cluster_id" {
  value = module.dev_eks.cluster_id
}

output "cluster_oidc_issuer_url" {
  value = module.dev_eks.cluster_oidc_issuer_url
}

output "cluster_platform_version" {
  value = module.dev_eks.cluster_platform_version
}


output "oidc_provider" {
  value = module.dev_eks.oidc_provider
}

output "oidc_provider_arn" {
  value = module.dev_eks.oidc_provider_arn
}


output "cluster_iam_role_arn" {
  value = module.dev_eks.cluster_iam_role_arn
}

output "cluster_addons" {
  value = module.dev_eks.cluster_addons
}
