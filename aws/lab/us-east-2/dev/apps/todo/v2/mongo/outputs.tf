output "cluster_name" {
  value = module.todo_mongo.cluster_name
}

output "arn" {
  value = module.todo_mongo.arn
}

output "writer_endpoint" {
  value = module.todo_mongo.writer_endpoint
}

output "reader_endpoint" {
  value = module.todo_mongo.reader_endpoint
}
