variable "stage" {
  type = string
}

variable "aws_region" {
  default = "us-east-1"
}

# Docker Cluster ==============================================

variable "image_tag" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

# Networking ==============================================
variable "vpc_id" {
  type = string
}

variable "domain" {
  type = string
}

variable "acm_cert_arn" {
  type = string
}

variable "app_port" {
  default = 8080
}

variable "mongo_port" {
  default = 27017
}

# File storage ==============================================
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

# variable "suppress_email" {
#   default = false
# }

# Compute Configuration ==========================================
variable "rds_instance_type" {
  default = "db.t3.micro"
}

variable "rds_instance_count" {
  default = 1
}

variable "memory" {
  default = 512
}

variable "cpu" {
  default = 256
}

# variable "num_workers" {
#   default = 2
# }

variable "allocated_storage" {
  default = 10
}

# App settings =====================================================
variable "jwt_expiration" {
  default = "5000d"
}


# Database settings =====================================================
variable "rds_db_name" {
  default = "mem"
}

variable "rds_backup_retention" {
  default = 7
}