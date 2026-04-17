variable "name" {
  description = "Project or environment prefix used for resource naming."
  type        = string
}

variable "vpc_cidr" {
  description = "Primary CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones used to spread the platform across multiple AZs."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets used by the ALB and NAT gateways."
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private application subnets used by ECS services."
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private database subnets used by RDS."
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "When true, uses a single shared NAT gateway to reduce non-production costs."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
