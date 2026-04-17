output "application_url" {
  description = "Primary HTTPS URL for the application."
  value       = "https://${trimsuffix(module.dns.fqdn, ".")}"
}

output "alb_dns_name" {
  description = "ALB DNS name."
  value       = module.alb.alb_dns_name
}

output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = module.ecs_service.cluster_name
}

output "rds_endpoint" {
  description = "RDS endpoint."
  value       = module.rds.db_endpoint
}
