output "db_instance_identifier" {
  description = "RDS instance identifier."
  value       = aws_db_instance.this.id
}

output "db_endpoint" {
  description = "Database endpoint."
  value       = aws_db_instance.this.address
}

output "db_security_group_id" {
  description = "Database security group identifier."
  value       = aws_security_group.db.id
}

output "secret_arn" {
  description = "Secrets Manager ARN containing the database credentials."
  value       = aws_secretsmanager_secret.db.arn
}
