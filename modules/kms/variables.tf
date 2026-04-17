variable "name" {
  description = "Name prefix for the KMS key and alias."
  type        = string
}

variable "description" {
  description = "Description for the KMS key."
  type        = string
}

variable "deletion_window_in_days" {
  description = "Scheduled deletion waiting period."
  type        = number
  default     = 30
}

variable "enable_key_rotation" {
  description = "Whether annual automatic key rotation is enabled."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
