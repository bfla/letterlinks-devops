variable "stage" {
  type = string
}

variable "domain" {
  type = string
}

variable "api_domain_name" {
  type = string
}

variable "app_domain_name" {
  type = string
}

variable "splash_domain_name" {
  type = string
}

variable "gmail_mx_val" {
  type = string
}

variable "lb_hostname" {
  type = string
}

variable "lb_zone_id"  {
  type = string
}

# variable "elb_hostname" {
#   type = string
# }

# variable "elb_zone_id" {
#   type = string
# }

# variable "nlb_hostname" {
#   type = string
# }

# variable "nlb_zone_id" {
#   type = string
# }

variable "app_cloudfront_domain" {
  type = string
}

variable "splash_cloudfront_domain" {
  type = string
}
# variable "gmail_verification_record" {
#   type = string
# }

# variable "gmail_dkim_record" {
#   type = string
# }