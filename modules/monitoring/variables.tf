variable "name" {
  description = "Name prefix for monitoring resources."
  type        = string
}

variable "alb_arn_suffix" {
  description = "ARN suffix for the ALB."
  type        = string
}

variable "target_group_arn_suffix" {
  description = "ARN suffix for the target group."
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name."
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name."
  type        = string
}

variable "db_instance_identifier" {
  description = "RDS DB instance identifier."
  type        = string
}

variable "alarm_actions" {
  description = "SNS topic ARNs or other alarm actions."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
