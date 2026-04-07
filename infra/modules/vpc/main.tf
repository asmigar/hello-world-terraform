data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "ecs" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "ecs"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ecs.id
  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_route_table" "public_custom_route_table" {
  vpc_id = aws_vpc.ecs.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block  = "::/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public-crt"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.ecs.id
  cidr_block              = cidrsubnet(aws_vpc.ecs.cidr_block, 8, count.index+ 1)
  ipv6_cidr_block       = cidrsubnet(aws_vpc.ecs.ipv6_cidr_block, 8, count.index+ 1)
  enable_resource_name_dns_aaaa_record_on_launch = true
  assign_ipv6_address_on_creation = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name  = "public_subnet_${count.index}"
    Stack = count.index
  }
}

resource "aws_route_table_association" "public_crt_public_subnet" {
  count = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_custom_route_table.id
}
