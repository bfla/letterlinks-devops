provider "aws" {
  region = var.region
}

resource "aws_secretsmanager_secret" "this" {
  name = "${var.name}"
  description = "${var.description}"
  tags = {
    stage = "${var.stage}"
    type = "${var.name}"
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(var.kv_pairs)
}