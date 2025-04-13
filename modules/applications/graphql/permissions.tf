# The IAM role that the task executor will assume ==============================
# These permissions are for the AWS service that orchestrates and runs tasks
resource "aws_iam_role" "task_exec" {
  name               = "graphql-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.task_exec.json
  tags = {
    Name        = "task-exec-iam-role"
    Application = "graphql"
  }
}

data "aws_iam_policy_document" "task_exec" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Attach the AWS Managed role for ECS Services
# resource "aws_iam_role_policy_attachment" "generic_task_exec" {
#   role       = aws_iam_role.task.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
# }

resource "aws_iam_role_policy_attachment" "generic_task_exec" {
  role       = aws_iam_role.task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Custom IAM permissions for the service (SecretManager, etc)
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
resource "aws_iam_policy" "task_exec" {
  name        = "graphql-task"
  description = "Permissions for the graphql ECS Service"
  policy      = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "secretsmanager:GetSecretValue"
          ]
          Effect   = "Allow"
          Resource = [
            "${data.aws_secretsmanager_secret.this.arn}",
            "${data.aws_secretsmanager_secret.this.arn}:*"
          ]
        },
        {
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams"
          ]
          Effect = "Allow"
          Resource = ["arn:aws:logs:*:*:*"]
        }
      ]
  })
}

# Attach a custom policy to allow the service to access to SecretManager secrets
resource "aws_iam_role_policy_attachment" "custom_task_exec" {
  role       = aws_iam_role.task_exec.name
  policy_arn = aws_iam_policy.task_exec.arn
}

# TASK PERMISSONS =============================================================
# These permissions are for the task/container/application.
# https://www.ericlondon.com/2017/08/15/deploying-application-to-aws-ecs-with-s3-integration-and-iam-policies-roles-using-terraform.html
data "aws_iam_policy_document" "task_role" {
  statement {
    sid = "ApplicationTaskRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Create an IAM role for the task/containers to assume
resource "aws_iam_role" "task" {
  name               = "${var.stage}-application-role"
  assume_role_policy = "${data.aws_iam_policy_document.task_role.json}"
}

data "aws_iam_policy_document" "task" {
  statement {
    sid = "ApplicationS3Buckets"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.private_data_bucket_name}"
      # "arn:aws:s3:::${var.public_media_bucket_name}",
      # "arn:aws:s3:::${var.export_bucket_name}"
    ]
  }
  statement {
    sid = "ApplicationS3Objects"
    effect = "Allow"
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      "arn:aws:s3:::${var.private_data_bucket_name}/*"
      # "arn:aws:s3:::${var.public_media_bucket_name}/*",
      # "arn:aws:s3:::${var.export_bucket_name}/*"
    ]
  }
}

resource "aws_iam_policy" "task" {
  name   = "${var.stage}-application"
  policy = "${data.aws_iam_policy_document.task.json}"
}

# Attach the IAM policy to the task role
resource "aws_iam_role_policy_attachment" "task" {
  role       = "${aws_iam_role.task.name}"
  policy_arn = "${aws_iam_policy.task.arn}"
}