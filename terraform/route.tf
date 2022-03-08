# パブリックサブネットのルート########################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public-1a" {
  subnet_id = aws_subnet.public-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-1c" {
  subnet_id = aws_subnet.public-1c.id
  route_table_id = aws_route_table.public.id
}
######################################################

# プライベートサブネットのルート######################
resource "aws_route_table" "private-1a" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "private-1c" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "private-1a" {
  route_table_id = aws_route_table.private-1a.id
  nat_gateway_id = aws_nat_gateway.ngw-1a.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private-1c" {
  route_table_id = aws_route_table.private-1c.id
  nat_gateway_id = aws_nat_gateway.ngw-1c.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private-1a" {
  subnet_id = aws_subnet.private-1a.id
  route_table_id = aws_route_table.private-1a.id
}

resource "aws_route_table_association" "private-1c" {
  subnet_id = aws_subnet.private-1c.id
  route_table_id = aws_route_table.private-1c.id
}
######################################################