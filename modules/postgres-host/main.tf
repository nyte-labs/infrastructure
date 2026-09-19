data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64"
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "postgres" {
  name        = "postgres-host"
  description = "Postgres host"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description     = "Postgres access from the app server"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.app_security_group_ids
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { Name = "postgres-host" }
}

resource "aws_instance" "postgres" {
  ami                         = data.aws_ssm_parameter.al2023_ami.value
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.postgres_host.name
  instance_type               = var.instance_type
  key_name                    = var.ssh_key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.postgres.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = templatefile("${path.module}/templates/init.sh.tpl", {
    admin_password  = var.admin_password
    db_app_password = var.db_app_password
    backup_bucket   = var.backup_bucket
    vpc_cidr        = data.aws_vpc.selected.cidr_block
  })

  tags = { Name = "postgres-host" }
}
