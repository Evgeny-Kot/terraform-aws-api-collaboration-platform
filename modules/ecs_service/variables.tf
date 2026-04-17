variable "name" {
  description = "Name prefix for the ECS resources."
  type        = string
}

variable "subnet_ids" {
  description = "Private application subnet identifiers."
  type        = list(string)
}

variable "service_security_group_id" {
  description = "Pre-created security group attached to the ECS tasks."
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN for the service."
  type        = string
}

variable "container_image" {
  description = "Container image for the API collaboration application."
  type        = string
}

variable "container_port" {
  description = "Application container port."
  type        = number
  default     = 8080
}

variable "cpu" {
  description = "Fargate CPU units."
  type        = number
}

variable "memory" {
  description = "Fargate memory in MiB."
  type        = number
}

variable "desired_count" {
  description = "Desired number of application tasks."
  type        = number
}

variable "min_capacity" {
  description = "Minimum autoscaling capacity."
  type        = number
}

variable "max_capacity" {
  description = "Maximum autoscaling capacity."
  type        = number
}

variable "environment_variables" {
  description = "Plaintext environment variables injected into the container."
  type        = map(string)
  default     = {}
}

variable "secret_arns" {
  description = "Map of environment variable names to Secrets Manager or SSM ARNs."
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  description = "KMS key ARN used for CloudWatch log group encryption."
  type        = string
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention period."
  type        = number
  default     = 30
}

variable "enable_execute_command" {
  description = "Enable ECS Exec for operational debugging."
  type        = bool
  default     = true
}

variable "health_check_grace_period_seconds" {
  description = "Grace period before ALB health checks count against a new task."
  type        = number
  default     = 60
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
