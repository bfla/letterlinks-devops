output "arn" {
  description = "ARN of the bucket"
  value = aws_s3_bucket.this.arn
}

output "name" {
  description = "Name of the bucket"
  value = aws_s3_bucket.this.id
}

output "domain_name" {
  description = "Domain name of Bucket"
  value = aws_s3_bucket.this.bucket_domain_name
}
