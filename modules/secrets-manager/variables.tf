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

variable "description" {
  type = string
  default = "Stores secrets"
}

variable "kv_pairs" {
  type = map(string)
}