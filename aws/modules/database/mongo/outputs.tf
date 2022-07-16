output "cluster_name" {
  value       = aws_docdb_cluster.this.*.cluster_identifier
  description = "Cluster Identifier."
}

output "arn" {
  value       = aws_docdb_cluster.this.*.arn
  description = "Amazon Resource Name (ARN) of the cluster."
}

output "writer_endpoint" {
  value       = aws_docdb_cluster.this.*.endpoint
  description = "Endpoint of the DocumentDB cluster."
}

output "reader_endpoint" {
  value       = aws_docdb_cluster.this.*.reader_endpoint
  description = "A read-only endpoint of the DocumentDB cluster, automatically load-balanced across replicas."
}
