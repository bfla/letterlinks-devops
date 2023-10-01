output "cloudfront_domain" {
  description = "CloudFront domain name"
  value = aws_cloudfront_distribution.splash.domain_name
}

output "cloudfront_zone_id" {
  description = "Hosted Route53 zone of the Cloudfront distribution"
  value       = aws_cloudfront_distribution.splash.hosted_zone_id
}

output "cloudfront_arn" {
  value = aws_cloudfront_distribution.splash.arn
}

output "bucket_arn" {
  value = aws_s3_bucket.splash.arn
}