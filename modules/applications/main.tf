provider "aws" {
  region      = var.region
}

locals {
  stage = var.stage
  domain      = "${var.sld}.${var.tld}"
  splash_domain = "www.${var.sld}.${var.tld}"
  app_domain  = "app.${var.sld}.${var.tld}"
  api_domain  = "api.${var.sld}.${var.tld}"
}

module "react-app" {
  source          = "./react-app"
  stage           = var.stage
  acm_cert_arn    = module.dns.acm_wildcard_cert_arn
  ssl_protocol    = var.ssl_protocol
  app_domain_name = local.app_domain
  sld             = var.sld
  tld             = var.tld
  # web_acl_arn     = module.dns.web_acl_arn # WAF firewall
  # log_bucket_name = var.log_bucket_name
  # log_bucket_domain_name = data.aws_s3_bucket.logs.bucket_domain_name
}

module "splash-page" {
  source = "./splash-page"
  stage = var.stage
  acm_cert_arn = module.dns.acm_cert_arn
  ssl_protocol    = var.ssl_protocol
  app_domain_name = local.splash_domain
  sld             = var.sld
  tld             = var.tld
}

module "dns" {
  source                = "./dns"
  stage                 = var.stage
  domain                = local.domain
  app_domain_name       = local.app_domain
  api_domain_name       = local.api_domain
  app_cloudfront_domain = module.react-app.cloudfront_domain
  splash_cloudfront_domain = module.splash-page.cloudfront_domain
  splash_domain_name    = local.splash_domain
}

module "cd" {
  source = "./cd"
  react_app_bucket_arn = module.react-app.bucket_arn
  react_app_cloudfront_arn = module.react-app.cloudfront_arn
}