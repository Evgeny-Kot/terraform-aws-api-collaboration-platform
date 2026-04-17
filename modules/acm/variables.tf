variable "domain_name" {
  description = "Primary DNS name to secure with ACM."
  type        = string
}

variable "subject_alternative_names" {
  description = "Optional SAN entries for the ACM certificate."
  type        = list(string)
  default     = []
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone identifier used for DNS validation."
  type        = string
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
