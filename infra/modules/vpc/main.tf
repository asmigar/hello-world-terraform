data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {}

resource "aws_vpc" "ecs" {
  cidr_block                       = var.vpc_cidr_block
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames             = true
  enable_dns_support               = true

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
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public-crt"
  }
}

resource "aws_subnet" "public" {
  count                                          = 2
  vpc_id                                         = aws_vpc.ecs.id
  cidr_block                                     = cidrsubnet(aws_vpc.ecs.cidr_block, 8, count.index + 1)
  ipv6_cidr_block                                = cidrsubnet(aws_vpc.ecs.ipv6_cidr_block, 8, count.index + 1)
  enable_resource_name_dns_aaaa_record_on_launch = true
  assign_ipv6_address_on_creation                = true
  availability_zone                              = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name  = "public_subnet_${count.index}"
    Stack = count.index
  }
}

resource "aws_subnet" "private" {
  count                                          = 2
  vpc_id                                         = aws_vpc.ecs.id
  ipv6_cidr_block                                = cidrsubnet(aws_vpc.ecs.ipv6_cidr_block, 8, count.index + 10)
  ipv6_native                                    = true
  enable_resource_name_dns_aaaa_record_on_launch = true
  assign_ipv6_address_on_creation                = true
  availability_zone                              = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name  = "private_subnet_${count.index}"
    Stack = count.index
  }
}


resource "aws_egress_only_internet_gateway" "eigw" {
  vpc_id = aws_vpc.ecs.id

  tags = {
    Name = "${var.env}-eigw"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.ecs.id

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.eigw.id
  }

  tags = {
    Name = "${var.env}-private-crt"
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "public_crt_public_subnet" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_custom_route_table.id
}
