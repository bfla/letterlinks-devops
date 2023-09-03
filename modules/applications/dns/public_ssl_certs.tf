# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation
resource "aws_route53_record" "domain_cert" {
  for_each = {
    for dvo in aws_acm_certificate.domain_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.domain.zone_id
}

resource "aws_acm_certificate" "domain_cert" {
  domain_name               = var.domain
  validation_method         = "DNS"
  subject_alternative_names = ["www.${var.domain}"]

  tags = {
    stage   = var.stage
    Name    = "${var.stage}-domain"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "domain_cert" {
  certificate_arn         = aws_acm_certificate.domain_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.domain_cert : record.fqdn]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation
resource "aws_acm_certificate" "api_cert" {
  domain_name       = var.api_domain_name
  validation_method = "DNS"
  # subject_alternative_names = []

  tags = {
    stage = var.stage
    Name = "${var.stage}-api-domain"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "api_cert" {
  for_each = {
    for dvo in aws_acm_certificate.api_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.domain.zone_id
}

resource "aws_acm_certificate_validation" "api_cert" {
  certificate_arn         = aws_acm_certificate.api_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.api_cert : record.fqdn]
}

resource "aws_acm_certificate" "wildcard_cert" {
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"
  # subject_alternative_names = []

  tags = {
    stage = var.stage
    Name = "${var.stage}-wildcard-domain"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "wildcard_cert" {
  for_each = {
    for dvo in aws_acm_certificate.wildcard_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.domain.zone_id
}

resource "aws_acm_certificate_validation" "wildcard_cert" {
  certificate_arn         = aws_acm_certificate.wildcard_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.wildcard_cert : record.fqdn]
}