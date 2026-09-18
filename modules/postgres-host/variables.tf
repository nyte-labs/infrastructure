variable "instance_type" {
  description = "EC2 instance type for the Postgres host"
  type        = string
  default     = "t4g.micro"
}

variable "ssh_key_name" {
  type = string
}

variable "app_security_group_ids" {
  description = "Security group IDs of app servers allowed to reach Postgres on 5432"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "admin_password" {
  description = "Postgres superuser password"
  type        = string
  sensitive   = true
}

variable "db_app_password" {
  description = "Password for the dionysus_app database role"
  type        = string
  sensitive   = true
}

variable "backup_bucket" {
  description = "S3 bucket name for pg_dump backups"
  type        = string
}
