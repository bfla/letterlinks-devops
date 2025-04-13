resource "aws_ecs_cluster" "this" {
  name = "${var.cluster_name}"
  tags = {
    Name = "${var.cluster_name}"
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = "${var.cluster_name}-ecs-logs"
  tags = {
    Name = "${var.cluster_name}"
  }
}