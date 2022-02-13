# module "http_sg" {
#   source = "./security_group"
#   name = "http_sg"
#   vpc_id = aws_vpc.vpc.id
#   port = 80
#   cidr_blocks = ["0.0.0.0/0"]
# }

# module "https_sg" {
#   source = "./security_group"
#   name = "https_sg"
#   vpc_id = aws_vpc.vpc.id
#   port = 443
#   cidr_blocks = ["0.0.0.0/0"]
# }

# module "front_sg" {
#   source = "./security_group"
#   name = "front_sg"
#   vpc_id = aws_vpc.vpc.id
#   port = 8080
#   cidr_blocks = [aws_vpc.vpc.cidr_block]
# }

# module "api_sg" {
#   source = "./security_group"
#   name = "api_sg"
#   vpc_id = aws_vpc.vpc.id
#   port = 3000
#   cidr_blocks = [aws_vpc.vpc.cidr_block]
# }

# module "mysql_sg" {
#   source = "./security_group"
#   name = "mysql_sg"
#   vpc_id = aws_vpc.vpc.id
#   port = 3306
#   cidr_blocks = [aws_vpc.vpc.cidr_block]
# }

# db ######################################################
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "rds_sg_rule1" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0", "0.0.0.0/16"]
  security_group_id = aws_security_group.rds_sg.id
}
resource "aws_security_group_rule" "rds_sg_rule2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds_sg.id
}
resource "aws_security_group_rule" "rds_sg_rule3" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.rds_sg.id
}
###########################################################

# alb #####################################################
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "alb_sg_rule2" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}
resource "aws_security_group_rule" "alb_sg_rule3" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}
resource "aws_security_group_rule" "alb_sg_rule4" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}
resource "aws_security_group_rule" "alb_sg_rule5" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}
resource "aws_security_group_rule" "alb_sg_rule6" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}
###########################################################

# ecs #####################################################
resource "aws_security_group" "ecs_sg" {
  vpc_id      = aws_vpc.vpc.id
  name        = "ecs_sg"
}

resource "aws_security_group_rule" "ecs_sg_rule2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_sg.id
}
resource "aws_security_group_rule" "ecs_sg_rule3" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_sg.id
}
resource "aws_security_group_rule" "ecs_sg_rule4" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_sg.id
}
resource "aws_security_group_rule" "ecs_sg_rule5" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.ecs_sg.id
}
resource "aws_security_group_rule" "ecs_sg_rule6" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_sg.id
}
resource "aws_security_group_rule" "ecs_sg_rule7" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_sg.id
}
###########################################################