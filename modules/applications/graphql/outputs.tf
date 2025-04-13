output "lb_hostname" {
  description = "Hostname for the load balancer"
  value = aws_alb.this.dns_name
}

output "lb_zone_id" {
  description = "Route53 Zone id for the load balancer"
  value = aws_alb.this.zone_id
}

# output "rds_security_group_id" {
#   value = aws_security_group.postgres.id
# }

# output "rds_port" {
#   value = aws_db_instance.this.port
# }

output "security_group_id" {
  value = aws_security_group.service.id
}

# output "db_instance_identifier" {
#   value = aws_db_instance.this.id
# }

output "db_security_group_id" {
  value = aws_security_group.docdb.id
}

output "mongo_url" {
  value = "${aws_docdb_cluster.cluster.endpoint}:${var.mongo_port}/?tls=true&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"
}