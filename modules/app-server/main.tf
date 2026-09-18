data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64"
}

resource "aws_security_group" "app" {
  name        = "${var.app_name}-app-server"
  description = "App server for ${var.app_name}"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    ipv6_cidr_blocks = [var.my_ip_cidr]
  }

  ingress {
    description      = "HTTP (IPv6)"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { Name = "${var.app_name}-app-server" }
}

resource "aws_instance" "app" {
  ami                         = data.aws_ssm_parameter.al2023_ami.value
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.app.name
  key_name                    = var.ssh_key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail
    dnf update -y
    dnf install -y docker
    systemctl enable --now docker
    usermod -aG docker ec2-user
  EOF

  tags = { Name = "${var.app_name}-app-server" }
}

resource "cloudflare_record" "app" {
  zone_id = var.cloudflare_zone_id
  name    = var.subdomain
  type    = "AAAA"
  content = aws_instance.app.ipv6_addresses[0]
  ttl     = 1
  proxied = true
}
