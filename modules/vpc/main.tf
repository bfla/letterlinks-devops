provider "aws" {
  region  = "${var.region}"
}

data "aws_availability_zones" "available" {}

# use the default AWS VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "main"
  }
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

# Create an internet gateway for the public subnet
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "main-vpc-gateway"
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_cidr_blocks)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.public_cidr_blocks, count.index)
  availability_zone       = element(local.azs, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "main-vpc-public-subnet-${count.index + 1}"
    private = "False"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "main-vpc-routing-table-public"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_cidr_blocks)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

/* Private subnet */
resource "aws_subnet" "private" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.private_cidr_blocks, count.index)
  availability_zone = element(local.azs, count.index)

  tags = {
    Name = "main-vpc-private-subnet-${count.index + 1}"
    private = "True"
  }
}