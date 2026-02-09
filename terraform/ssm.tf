resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.environment}/${var.project}/db_password"
  type  = "SecureString"
  value = var.db_password
}

