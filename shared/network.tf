// Q: should I use a prepackaged terraform module for this?

resource "aws_ecs_cluster" "shared_cluster" {
  name = "shared_cluster"
}

resource "aws_vpc" "shared_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.shared_vpc.id
  cidr_block = var.subnet_cidr
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.shared_vpc.id
  cidr_block = var.public_subnet1
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.shared_vpc.id
  cidr_block = var.public_subnet2
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.shared_vpc.id
  tags = {
    Name = "main"
  }
}

// Q: what do these do?
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.shared_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.shared_vpc.id
  route_table_id = aws_route_table.main.id
}