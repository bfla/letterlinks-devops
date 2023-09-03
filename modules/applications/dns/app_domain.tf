 # api.domain
resource "aws_route53_record" "react-app-a-record" {
  allow_overwrite = true
  name            = "${var.app_domain_name}."
  records         = [var.app_cloudfront_domain]
  ttl             = 60
  type            = "CNAME"
  zone_id         = aws_route53_zone.domain.zone_id
}