variable "aws_region" {
  type        = string
  description = "AWS region where the backend resources are created."
  default     = "us-east-1"
}

variable "state_bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name for Terraform state."
}

variable "lock_table_name" {
  type        = string
  description = "DynamoDB table used for Terraform state locking."
}

variable "tags" {
  type        = map(string)
  description = "Common tags for backend resources."
  default = {
    ManagedBy = "Terraform"
    Purpose   = "terraform-backend"
  }
}
