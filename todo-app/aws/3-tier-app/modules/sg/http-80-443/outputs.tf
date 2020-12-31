output "sg_id" {
  description = "The ID of the sg"
  value       = module.sg_http_80_443.this_security_group_id
}