# サブネットグループ ################################################
resource "aws_db_subnet_group" "nurse" {
  name = "nurse"
  subnet_ids = [aws_subnet.private-1a.id, aws_subnet.private-1c.id]
}
#####################################################################

# インスタンス ######################################################
resource "aws_db_instance" "nurse" {
  identifier = "nurse"
  name = "nurse"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  max_allocated_storage = 100
  storage_type = "gp2"
  # storage_encrypted = true
  # kms_key_id = aws_kms_key.nurse.arn
  username = var.DATABASE_USER_NAME
  password = var.DATABASE_PASSWORD
  multi_az = true
  publicly_accessible = false
  backup_retention_period = 30
  auto_minor_version_upgrade = false
  deletion_protection = false
  skip_final_snapshot = true
  port = 3306
  apply_immediately = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.nurse.name
}
#####################################################################