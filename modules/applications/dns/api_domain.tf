resource "aws_route53_record" "api-a-record" {
  allow_overwrite = true
  name            = "${var.api_domain_name}."
  # records         = [var.elb_hostname]
  # ttl             = 60
  type            = "A"
  zone_id         = aws_route53_zone.domain.zone_id

  alias {
    name = var.lb_hostname
    # zone_id = aws_route53_zone.domain.zone_id
    zone_id = var.lb_zone_id
    evaluate_target_health = true
  }
}