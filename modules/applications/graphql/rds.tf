data "aws_region" "current" {}

locals {
  subnet_name = "${var.stage}-docdb-subnet-group"
}

resource "aws_docdb_cluster_parameter_group" "parameter_group" {
  family      = "docdb5.0"
  name        = "${var.stage}-default"
  description = "docdb cluster parameter group"

  parameter {
    name  = "tls"
    value = "enabled"
  }

  # parameter {
  #   name = "audit_logs"
  #   value = "all"
  # }
}

resource "aws_docdb_cluster" "cluster" {
  cluster_identifier      = "${var.stage}-app-db"
  engine                  = "docdb"
  port                    = var.mongo_port
  master_username         = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["rds_username"]
  master_password         = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["rds_password"]
  backup_retention_period = var.rds_backup_retention
  preferred_backup_window = "01:00-03:00"
  skip_final_snapshot     = true
  storage_encrypted       = true
  db_subnet_group_name    = local.subnet_name
  db_cluster_parameter_group_name = "${var.stage}-default"
  vpc_security_group_ids  = [
    aws_security_group.docdb.id
  ]
  tags = {
    stage = var.stage
  }
  depends_on = [
    aws_docdb_subnet_group.docdb,
    aws_docdb_cluster_parameter_group.parameter_group
  ]
  # port                    = 27001
  # enabled_cloudwatch_logs_exports = ["audit"]
  # deletion_protection = true
  # availability_zones = []
}

resource "aws_docdb_cluster_instance" "instances" {
  instance_class     = var.rds_instance_type
  count              = var.rds_instance_count
  identifier         = "${var.stage}-docdb-cluster-${count.index}"
  cluster_identifier = aws_docdb_cluster.cluster.id
  tags = {
    stage = var.stage
  }
}
