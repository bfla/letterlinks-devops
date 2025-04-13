output "arn" {
  description = "ARN of the bucket"
  value = aws_secretsmanager_secret.this.id
}