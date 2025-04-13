variable "stage" {
  type = string
  description = "Environment like prod, staging, etc"
}

variable "sld" {
  type = string
}

variable "tld" {
  type = string
}

variable "region" {
  type = string
  description = "AWS region"
  default = "us-east-1"
}

variable "vpc_id" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "app_memory" {
  default = 512
}

variable "app_cpu" {
  default = 256
}

variable "rds_instance_type" {
  type = string
}

variable "ssl_protocol" {
  default = "TLSv1.2"
}

variable "gmail_mx_val" {
  type = string
}

# variable "keypair_name" {
#   type = string
# }

variable "trusted_ip_addresses" {
  type = list(string)
  default = []
}

# variable "extra_dns_records" {
#   default = []
#   type = list(object({
#     name = string
#     type = string
#     records = list(string)
#     ttl = optional(number)
#     alias = optional(bool, false)
#   }))
#   description = "A list of DNS records"
# }
