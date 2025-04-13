# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_awslogs.html
resource "aws_cloudwatch_log_group" "this" {
  name = "graphql"
  # retention_in_days = 2192 # 6 years: Required by law under HHS HIPAA Security Rule!
  retention_in_days = 30
  tags = {
    Application = "graphql"
  }

  lifecycle {
    prevent_destroy = true
  }
}