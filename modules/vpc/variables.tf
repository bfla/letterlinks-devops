variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  default = "10.10.0.0/16"
}

variable "public_cidr_blocks" {
  default = ["10.10.100.0/24", "10.10.101.0/24"]
}

variable "private_cidr_blocks" {
  default = ["10.10.0.0/24", "10.10.1.0/24"]
}