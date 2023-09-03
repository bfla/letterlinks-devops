output "name_servers" {
  description = "DNS nameservers for Route53 Zone"
  value = aws_route53_zone.domain.name_servers
}

output "acm_cert_arn" {
  description = "ACM certificate ARN for main domain"
  value = aws_acm_certificate.domain_cert.arn
}

output "api_acm_cert_arn" {
  description = "ACM certificate ARN for api domain"
  value = aws_acm_certificate.api_cert.arn
}

output "acm_wildcard_cert_arn" {
  description = "ACM certificate ARN for wildcard subdomains"
  value = aws_acm_certificate.wildcard_cert.arn
}

# output "web_acl_arn" {
#   description = "AWS WAF Web ACL arn"
#   value = aws_wafv2_web_acl.this.arn
# }