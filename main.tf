resource "aws_s3_bucket" "main" {
  bucket = "nyte-labs"
}

module "app_dionysus" {
  source = "./modules/app-server"

  app_name           = "dionysus"
  subdomain          = "dionysus"
  ssh_key_name       = var.ssh_key_name
  my_ip_cidr         = var.my_ip_cidr
  vpc_id             = aws_vpc.main.id
  subnet_id          = aws_subnet.main.id
  cloudflare_zone_id = var.cloudflare_zone_id
  domain_name        = var.domain_name
}

module "postgres_host" {
  source = "./modules/postgres-host"

  ssh_key_name    = var.ssh_key_name
  vpc_id          = aws_vpc.main.id
  subnet_id       = aws_subnet.main.id
  admin_password  = var.postgres_admin_password
  backup_bucket   = var.backup_bucket
  db_app_password = var.db_app_password

  app_security_group_ids = [
    module.app_dionysus.security_group_id
  ]
}
