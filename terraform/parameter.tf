# 一覧 ##############################################
# api
variable "RAILS_MASTER_KEY" {}
variable "API_DOMAIN" {}
variable "DATABASE_URL" {}

# front
# variable "BASE_URL" {}
# variable "BROWSER_BASE_URL" {}
variable "API_URL"{}

# db
variable "DATABASE_USER_NAME" {}
variable "DATABASE_PASSWORD" {}
#####################################################

# api ###############################################
resource "aws_ssm_parameter" "RAILS_MASTER_KEY" {
  name = "RAILS_MASTER_KEY"
  value = var.RAILS_MASTER_KEY
  type = "SecureString"
}

resource "aws_ssm_parameter" "RAILS_ENV" {
  name = "RAILS_ENV"
  value = "production"
  type = "String"
}

resource "aws_ssm_parameter" "API_DOMAIN" {
  name = "API_DOMAIN"
  value = var.API_DOMAIN
  type = "SecureString"
}

resource "aws_ssm_parameter" "DATABASE_URL" {
  name = "DATABASE_URL"
  value = var.DATABASE_URL
  type = "SecureString"
}
#####################################################

# front #############################################
resource "aws_ssm_parameter" "API_URL" {
  name = "API_URL"
  value = var.API_URL
  type = "SecureString"
}
#####################################################

# db ################################################
resource "aws_ssm_parameter" "DATABASE_USER_NAME" {
  name = "DATABASE_USER_NAME"
  value = var.DATABASE_USER_NAME
  type = "SecureString"
}

resource "aws_ssm_parameter" "DATABASE_PASSWORD" {
  name = "DATABASE_PASSWORD"
  value = var.DATABASE_PASSWORD
  type = "SecureString"
}
#####################################################