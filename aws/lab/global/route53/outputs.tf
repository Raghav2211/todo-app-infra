output "route53_zone_names" {
  value = keys(module.zones.route53_zone_name)
}

output "route53_zone_ids" {
  value = values(module.zones.route53_zone_zone_id)
}