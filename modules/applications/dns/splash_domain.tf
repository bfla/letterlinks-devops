 # api.domain
resource "aws_route53_record" "splash-a-record" {
  allow_overwrite = true
  name            = "${var.splash_domain_name}."
  records         = [var.splash_cloudfront_domain]
  ttl             = 60
  type            = "CNAME"
  zone_id         = aws_route53_zone.domain.zone_id
}