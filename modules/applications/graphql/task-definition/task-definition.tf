locals {
  mongo_url = "mongodb://${jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["rds_username"]}:${jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["rds_password"]}@${var.rds_hostname}:${var.rds_port}/?tls=true&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"
}

resource "aws_ecs_task_definition" "this" {
  family = "${var.app_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "${var.memory}"
  cpu                      = "${var.cpu}"
  execution_role_arn       = "${var.task_exec_arn}"
  task_role_arn            = "${var.task_role_arn}"

  tags = {
    Application = var.app_name
  }

  # mongodb://localuser:alohomora@localhost:27017
  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.app_name}",
      "image": "${data.aws_ecr_repository.this.repository_url}:${var.image_tag}",
      "entryPoint": ${jsonencode(var.entry_point)},
      "essential": true,
      "cpu": ${var.cpu},
      "memory": ${var.memory},
      "networkMode": "awsvpc",
      "portMappings": [
        {
          "name": "graphql",
          "containerPort": ${var.app_port},
          "hostPort": ${var.app_port},
          "protocol": "tcp"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${data.aws_cloudwatch_log_group.this.id}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "${var.app_name}",
          "awslogs-create-group": "true"
        }
      },
      "environment": [
        {
          "name": "PORT",
          "value": "${var.app_port}"
        },
        {
          "name": "NODE_ENV",
          "value": "PRODUCTION"
        },
        {
          "name": "LOG_DIR",
          "value": "./logs"
        },
        { 
          "name": "RDS_DB_NAME",
          "value": "${var.rds_db_name}"
        },
        { 
          "name": "RDS_HOSTNAME",
          "value": "${var.rds_hostname}"
        },
        { 
          "name": "RDS_PORT",
          "value": "${var.rds_port}"
        },
        {
          "name": "MONGO_TLS_CA_FILE_PATH",
          "value": "/usr/src/app/mem/apps/graphql/certs/rds-combined-ca-bundle.pem"
        },
        {
          "name": "ALLOWED_HOST",
          "value": "${var.domain}"
        },
        {
          "name": "JWT_EXPIRES_IN",
          "value": "${var.jwt_expiration}"
        },
        {
          "name": "AWS_REGION",
          "value": "${var.aws_region}"
        },
        {
          "name": "PRIVATE_S3_BUCKET",
          "value": "${var.private_data_bucket_name}"
        }
      ],
      "secrets": [
        {
          "name": "JWT_SECRET",
          "valueFrom": "${data.aws_secretsmanager_secret.this.arn}:jwt_secret::"
        },
        {
          "name": "MONGO_URL",
          "valueFrom": "${data.aws_secretsmanager_secret.this.arn}:mongo_url::"
        },
        {
          "name": "RDS_PASSWORD",
          "valueFrom": "${data.aws_secretsmanager_secret.this.arn}:rds_password::"
        },
        {
          "name": "RDS_USERNAME",
          "valueFrom": "${data.aws_secretsmanager_secret.this.arn}:rds_username::"
        },
        {
          "name": "ELEVENLABS_API_KEY",
          "valueFrom": "${data.aws_secretsmanager_secret.this.arn}:elevenlabs_api_key::"
        }
      ]
    }
  ]
  DEFINITION
}