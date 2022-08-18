output "cluster_name" {
  value = module.dev_mongo.cluster_name
}

output "arn" {
  value = module.dev_mongo.arn
}

output "writer_endpoint" {
  value = module.dev_mongo.writer_endpoint
}

output "reader_endpoint" {
  value = module.dev_mongo.reader_endpoint
}
