# パブリックサブネット
resource "aws_subnet" "public-1a" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "public in 1a"
  }
}

resource "aws_subnet" "public-1c" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "public in 1c"
  }
}

# プライベートサブネット
resource "aws_subnet" "private-1a" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.64.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "private-1a"
  }
}

resource "aws_subnet" "private-1c" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.65.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "private-1c"
  }
}