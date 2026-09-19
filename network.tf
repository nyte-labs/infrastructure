resource "aws_vpc" "main" {
  cidr_block                       = "10.20.0.0/24"
  assign_generated_ipv6_cidr_block = true
  enable_dns_support               = true
  enable_dns_hostnames             = true

  tags = { Name = "nyte-labs-vpc" }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "nyte-labs-igw" }
}

resource "aws_subnet" "main" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = "10.20.0.0/28"
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 0)
  availability_zone               = "eu-central-1a"
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  tags = { Name = "nyte-labs-subnet" }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.main.id
  }

  tags = { Name = "nyte-labs-rtb" }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}