resource "aws_iam_role" "postgres_host" {
  name = "postgres-host-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "backup_s3_write" {
  name = "postgres-backup-s3-write"
  role = aws_iam_role.postgres_host.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:PutObject"]
      Resource = "arn:aws:s3:::${var.backup_bucket}/*"
    }]
  })
}

resource "aws_iam_instance_profile" "postgres_host" {
  name = "postgres-host-profile"
  role = aws_iam_role.postgres_host.name
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.postgres_host.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}