// Create the VPC
resource  "aws_vpc" "vpc" {
  cidr_block           =  var.vpc_cidr
  enable_dns_support   =  var.enable_dns_support
  enable_dns_hostnames =  var.enable_dns_hostnames

  tags = {
    Name = "${var.name}"
  }
}

// Create the IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = { 
  	Name = "${var.name}-igw"
  }
}

// Create Public Subnets
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(split(",", var.public_subnets_cidr)) 

  # gettin cidr id one by one 
  cidr_block              = element(split(",", var.public_subnets_cidr), count.index)
  availability_zone       = element(split(",", var.azs), count.index)

  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "${var.name}-public-${element(split(",", var.azs), count.index)}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(split(",", var.public_subnets_cidr))
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

//Creating private subnets 
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(split(",", var.private_subnets_cidr)) 

  # getting cidr id one by one 
  cidr_block              = element(split(",", var.private_subnets_cidr), count.index)
  availability_zone       = element(split(",", var.azs), count.index)

  tags = {
    Name = "${var.name}-private-${element(split(",", var.azs), count.index)}"
  }
}

resource "aws_eip" "e_ip" {
  vpc      = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.e_ip.id
  subnet_id     = element(aws_subnet.public.*.id, 1)

  tags = {
    Name = "NAT-Gateway"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name = "${var.name}-private"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(split(",", var.private_subnets_cidr))
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

# Output Section
output "public_subnets_id" {
  value = join(",", aws_subnet.public.*.id)
}

output "private_subnets_id" {
  value = join(",", aws_subnet.private.*.id)
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}