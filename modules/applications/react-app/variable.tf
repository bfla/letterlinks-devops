variable "stage" {
  type = string
}


variable "app_domain_name" {
  type = string
}

variable "acm_cert_arn" {
  type = string
}

variable "sld" {
  type = string
}

variable "tld" {
  type = string
}

variable "ssl_protocol" {
  type = string
}

variable "service_name" {
  type = string
  default = "react-app"
}

# variable "site_basic_auth" {
#   type = object({
#     required = bool
#     username = string
#     password = string
#   })
#   default = {
#     required = false
#     username = "secret"
#     password = "sgdsfas54fgs!"
#   }
# }

# variable "basic_auth_username" {
#   type = string
#   default = "dumbledore"
# }

# variable "basic_auth_password" {
#   type = string
#   default = "alohomora"
# }

# variable "log_bucket_domain_name" {
#   type = string
# }

# variable "log_bucket_name" {
#   type = string
# }

# variable "web_acl_arn" {
#   type = string
# }