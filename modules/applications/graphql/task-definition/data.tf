locals {
  is_staging = var.stage == "staging" ? "True" : "False"
  is_production = var.stage == "prod" ? "True" : "False"
}

data "aws_ecs_cluster" "default" {
  cluster_name = var.ecs_cluster_name
}

data "aws_secretsmanager_secret" "this" {
  name = "${var.stage}-terraform"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.this.id
}

data "aws_cloudwatch_log_group" "this" {
  # name = "${var.ecs_cluster_name}-ecs-logs"
  # name = var.log_group_name
  name = "graphql"
}

data "aws_ecr_repository" "this" {
  name = "graphql"
}