# Container settings

variable "app_name" {
  type = string
}

variable "entry_point" {
  description = "The entry point for the container"
  type = list(string)
  default = ["./start.sh", "8080"]
}

variable "task_exec_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "log_group_name" {
  type = string
}

variable "stage" {
  type = string
}

variable "aws_region" {
  default = "us-east-1"
}

variable "app_port" {
  default = 8080
}

variable "image_tag" {
  type = string
}

variable "memory" {
  default = 512
}

variable "cpu" {
  default = 256
}

# Django settings
variable "rds_db_name" {
  type = string
}

variable "rds_hostname" {
  type = string
}

variable "rds_port" {
  default = 5432
}

variable "domain" {
  type = string
}

# variable "suppress_email" {
#   default = false
# }

variable "jwt_expiration" {
  default = "5000d"
}

# File Storage

variable "private_data_bucket_name" {
  type = string
}

# variable "cdn_hostname" {
#   type = string
# }

# variable "public_media_bucket_name" {
#   type = string
# }


# variable "export_bucket_name" {
#   type = string
# }