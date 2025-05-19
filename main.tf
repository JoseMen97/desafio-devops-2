# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc

  tags = {
    Name = "VPC-main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# Subnet public
resource "aws_subnet" "public" {
  for_each   = { for idx, cidr in var.public_subnet : idx => cidr }
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Subnet private
resource "aws_subnet" "private" {
  for_each   = { for idx, cidr in var.private_subnet : idx => cidr }
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
}

resource "aws_eip" "nat" {
  for_each = aws_subnet.public
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat" {
  for_each      = aws_subnet.public
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  for_each = aws_subnet.private
  vpc_id   = aws_vpc.main.id
}

resource "aws_route" "private_nat" {
  for_each               = aws_nat_gateway.nat
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = each.value.id
}
