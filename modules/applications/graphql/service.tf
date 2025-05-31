data "aws_ecs_cluster" "default" {
  cluster_name = var.ecs_cluster_name
}

data "aws_secretsmanager_secret" "this" {
  name = "${var.stage}-terraform"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.this.id
}

module "task_definition" {
  source = "./task-definition"
  app_name = "graphql"
  ecs_cluster_name = var.ecs_cluster_name
  stage = var.stage
  aws_region = var.aws_region
  log_group_name = aws_cloudwatch_log_group.this.name
  # container settings
  entry_point = ["./start-graphql.sh"]
  cpu = var.cpu
  memory = var.memory
  image_tag = var.image_tag
  task_exec_arn = aws_iam_role.task_exec.arn
  task_role_arn = aws_iam_role.task.arn
  # App settings
  domain = var.domain
  jwt_expiration = var.jwt_expiration
  # suppress_email = var.suppress_email
  # RDS
  rds_db_name = var.rds_db_name
  rds_hostname = aws_docdb_cluster.cluster.endpoint
  rds_port = var.mongo_port
  # File storage
  private_data_bucket_name = var.private_data_bucket_name
  # cdn_hostname = var.cdn_hostname
  # public_media_bucket_name = var.public_media_bucket_name
  # export_bucket_name = var.export_bucket_name
  # depends on
  depends_on = [aws_cloudwatch_log_group.this]
}

# https://dev.to/thnery/create-an-aws-ecs-cluster-using-terraform-g80
resource "aws_ecs_service" "graphql" {
  name            = "graphql"
  cluster         = data.aws_ecs_cluster.default.id
  task_definition = "${module.task_definition.family}:${max(module.task_definition.revision, module.task_definition.revision)}"
  desired_count   = 1
  # depends_on      = [aws_iam_role.task_exec, aws_lb_listener.graphql]
  force_new_deployment = true
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"

  network_configuration {
    # TODO: Ideally, these would be deployed on a private subnect without public
    # IP addresses.  But that requires either a NAT gateway or VPC Peering:
    # https://stackoverflow.com/questions/61265108/aws-ecs-fargate-resourceinitializationerror-unable-to-pull-secrets-or-registry
    subnets          = data.aws_subnets.public.ids
    assign_public_ip = true
    security_groups = [aws_security_group.service.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "graphql"
    container_port   = var.app_port
  }

  tags = {
    Application = "graphql"
  }
}