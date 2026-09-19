variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "eu-central-1"
}

variable "ssh_key_name" {
  description = "Name of an existing EC2 key pair for SSH access"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID for nytelabs.dev"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token, scoped to Zone:DNS:Edit for the nytelabs.dev zone"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Root domain, e.g. example.com"
  type        = string
}

variable "my_ip_cidr" {
  description = "Your IP in CIDR form, for restricting SSH access, e.g. 1.2.3.4/32"
  type        = string
}

variable "postgres_admin_password" {
  description = "Master password for the Postgres superuser"
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
