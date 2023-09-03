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

variable "ssl_protocol" {
  default = "TLSv1.2"
}


