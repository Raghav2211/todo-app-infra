output "k8s_version" {
  value = local.k8s_version
}

output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "cluster_platform_version" {
  value = module.eks.cluster_platform_version
}


output "oidc_provider" {
  value = module.eks.oidc_provider
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}


output "cluster_iam_role_arn" {
  value = module.eks.cluster_iam_role_arn
}

output "cluster_addons" {
  value = module.eks.cluster_addons
}