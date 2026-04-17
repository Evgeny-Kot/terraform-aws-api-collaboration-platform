variable "name" {
  description = "Name prefix for database resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC identifier."
  type        = string
}

variable "subnet_ids" {
  description = "Private database subnet identifiers."
  type        = list(string)
}

variable "app_security_group_id" {
  description = "Security group attached to ECS tasks that need database access."
  type        = string
}

variable "db_name" {
  description = "Initial PostgreSQL database name."
  type        = string
}

variable "username" {
  description = "Master username for the PostgreSQL instance."
  type        = string
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
}

variable "allocated_storage" {
  description = "Initial allocated storage in GiB."
  type        = number
}

variable "max_allocated_storage" {
  description = "Upper autoscaling storage limit in GiB."
  type        = number
}

variable "engine_version" {
  description = "PostgreSQL engine version."
  type        = string
  default     = "15.6"
}

variable "backup_retention_period" {
  description = "Backup retention window in days."
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Enable deletion protection."
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip the final DB snapshot on destroy."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "KMS key ARN for storage encryption and secret encryption."
  type        = string
}

variable "performance_insights_enabled" {
  description = "Enable Performance Insights."
  type        = bool
  default     = true
}

variable "multi_az" {
  description = "Create a Multi-AZ RDS deployment."
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  description = "Enhanced monitoring interval in seconds."
  type        = number
  default     = 60
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
