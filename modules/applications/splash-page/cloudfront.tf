# https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html#oac-permission-to-access-s3

locals {
  s3_origin_id = "${var.stage}-${var.service_name}"
}

resource "aws_cloudfront_origin_access_control" "splash" {
  name                              = "${var.stage}-${var.service_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "splash" {
  comment = "Cloudfront Distribution pointing to S3 bucket for ${var.stage} ${var.service_name}"
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = [var.app_domain_name]
  price_class         = "PriceClass_100"
  # web_acl_id          = "${var.web_acl_arn}" # firewall
  origin {
    domain_name = aws_s3_bucket.splash.bucket_regional_domain_name
    origin_id = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.splash.id
  }
  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["CN", "IN", "NG", "RU"]
    }
  }
  viewer_certificate {
    acm_certificate_arn = var.acm_cert_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
  # logging_config {
  #   include_cookies = false
  #   bucket          = var.log_bucket_domain_name
  #   prefix          = "cloudfront/${var.service_name}/"
  # }
  default_cache_behavior {
    target_origin_id = local.s3_origin_id
    allowed_methods =   ["GET", "HEAD", "OPTIONS"]
    cached_methods  =   ["GET", "HEAD", "OPTIONS"]
    compress = true
    viewer_protocol_policy = "redirect-to-https"
    smooth_streaming = false
    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
  }

  tags = {
    Name = "${var.stage}-${var.service_name}"
    stage = var.stage
  }
}