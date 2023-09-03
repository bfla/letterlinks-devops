variable "stage" {
  type = string
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "name" {
  type = string
}

variable "logging" {
  type = bool
  default = false
}

variable "cloudtrail_log_prefix" {
  type = string
  default = "cloudtrail"
}
