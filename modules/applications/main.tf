provider "aws" {
  region      = var.region
}

locals {
  stage = var.stage
  domain      = "${var.sld}.${var.tld}"
  splash_domain = "www.${var.sld}.${var.tld}"
  app_domain  = "app.${var.sld}.${var.tld}"
  api_domain  = "api.${var.sld}.${var.tld}"
  private_data_bucket_name = "${var.stage}-mem-private-data"
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

module "graphql" {
  source            = "./graphql"
  app_port          = 8080
  stage             = var.stage
  aws_region        = var.region
  vpc_id            = var.vpc_id
  image_tag         = var.image_tag
  ecs_cluster_name  = var.ecs_cluster_name
  rds_instance_type = var.rds_instance_type
  domain            = local.api_domain
  memory            = var.app_memory
  cpu               = var.app_cpu
  acm_cert_arn      = module.dns.api_acm_cert_arn
  private_data_bucket_name = local.private_data_bucket_name
  # cdn_hostname      = module.file-storage.public_cdn_hostname
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

module "file-storage" {
  source = "./file-storage"
  stage = var.stage
  region = var.region
  private_data_bucket_name = local.private_data_bucket_name
}

module "dns" {
  source                = "./dns"
  stage                 = var.stage
  domain                = local.domain
  app_domain_name       = local.app_domain
  api_domain_name       = local.api_domain
  lb_hostname            = module.graphql.lb_hostname
  lb_zone_id             = module.graphql.lb_zone_id
  app_cloudfront_domain = module.react-app.cloudfront_domain
  splash_cloudfront_domain = module.splash-page.cloudfront_domain
  splash_domain_name    = local.splash_domain
  gmail_mx_val         = var.gmail_mx_val
}

module "cd" {
  source = "./cd"
  react_app_bucket_arn = module.react-app.bucket_arn
  react_app_cloudfront_arn = module.react-app.cloudfront_arn
}

module "pi" {
  source = "./pi"
}