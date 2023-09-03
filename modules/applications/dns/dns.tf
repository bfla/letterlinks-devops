resource "aws_route53_zone" "domain" {
  name         = var.domain

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    stage = var.stage
  }
}