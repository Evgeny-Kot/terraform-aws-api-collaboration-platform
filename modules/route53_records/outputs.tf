output "fqdn" {
  description = "Fully qualified DNS name created for the application."
  value       = aws_route53_record.app_a.fqdn
}
