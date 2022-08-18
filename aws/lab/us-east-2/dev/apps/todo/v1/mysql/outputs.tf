output "todo_app_ingress_security_id" {
  value = module.mysql_sg.this_security_group_id
}

output "instance_address" {
  value = module.mysql.db_instance_address
}

output "instance_endpoint" {
  value = module.mysql.db_instance_endpoint
}

output "port" {
  value = module.mysql.port
}
