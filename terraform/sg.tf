module "http_sg" {
  source = "./security_group"
  name = "http_sg"
  vpc_id = aws_vpc.vpc.id
  port = 80
  cidr_blocks = ["0.0.0.0/0"]
}

module "https_sg" {
  source = "./security_group"
  name = "https_sg"
  vpc_id = aws_vpc.vpc.id
  port = 443
  cidr_blocks = ["0.0.0.0/0"]
}

module "front_sg" {
  source = "./security_group"
  name = "front_sg"
  vpc_id = aws_vpc.vpc.id
  port = 8080
  cidr_blocks = [aws_vpc.vpc.cidr_block]
}

module "api_sg" {
  source = "./security_group"
  name = "api_sg"
  vpc_id = aws_vpc.vpc.id
  port = 3000
  cidr_blocks = ["0.0.0.0/0"]
}

module "from_alb_sg" {
  source = "./security_group"
  name = "from_alb_sg"
  vpc_id = aws_vpc.vpc.id
  port = 3000
  cidr_blocks = [aws_vpc.vpc.cidr_block]
}

module "mysql_sg" {
  source = "./security_group"
  name = "mysql_sg"
  vpc_id = aws_vpc.vpc.id
  port = 3306
  cidr_blocks = [aws_vpc.vpc.cidr_block]
}