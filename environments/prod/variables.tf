variable "aws_region" {
  description = "AWS region for the deployment."
  type        = string
}

variable "project_name" {
  description = "Project name used for naming and tagging."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "owner" {
  description = "Owner tag."
  type        = string
}

variable "domain_name" {
  description = "Fully qualified DNS record for the application."
  type        = string
}

variable "health_check_path" {
  description = "ALB and application health check endpoint."
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID that owns the application record."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones used by the environment."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks."
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "Private application subnet CIDR blocks."
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "Private database subnet CIDR blocks."
  type        = list(string)
}

variable "container_image" {
  description = "Application image deployed to ECS."
  type        = string
}

variable "app_cpu" {
  description = "ECS task CPU units."
  type        = number
}

variable "app_memory" {
  description = "ECS task memory in MiB."
  type        = number
}

variable "desired_count" {
  description = "Desired ECS task count."
  type        = number
}

variable "min_capacity" {
  description = "Minimum ECS autoscaling capacity."
  type        = number
}

variable "max_capacity" {
  description = "Maximum ECS autoscaling capacity."
  type        = number
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated RDS storage in GiB."
  type        = number
}

variable "db_max_allocated_storage" {
  description = "Maximum autoscaled RDS storage in GiB."
  type        = number
}

variable "db_name" {
  description = "Application database name."
  type        = string
}

variable "db_username" {
  description = "Database master username."
  type        = string
}

variable "alarm_email_endpoints" {
  description = "Email subscriptions for infrastructure alerts."
  type        = list(string)
  default     = []
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention period for ECS logs."
  type        = number
}

variable "single_nat_gateway" {
  description = "Use one NAT gateway to reduce lower-environment cost."
  type        = bool
}
