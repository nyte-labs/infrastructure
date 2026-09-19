variable "app_name" {
  description = "Short name for tags and DNS"
  type        = string
}

variable "subdomain" {
  description = "Subdomain to point at this instance"
  type        = string
}

variable "instance_type" {
  type    = string
  default = "t4g.micro"
}

variable "ssh_key_name" {
  type = string
}

variable "my_ip_cidr" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "cloudflare_zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}
