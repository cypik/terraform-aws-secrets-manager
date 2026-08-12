variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "repository" {
  type        = string
  default     = "https://github.com/cypik/terraform-aws-secrets-manager"
  description = "Terraform current module repo"
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. `name`."
}

variable "managedby" {
  type        = string
  default     = "info@cypik.com"
  description = "ManagedBy, eg 'info@cypik.com'"
}

variable "attributes" {
  type        = list(any)
  default     = []
  description = "Additional attributes (e.g. `1`)."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Flag to control the vpc creation."
}

variable "recovery_window_in_days" {
  type        = number
  default     = 30
  description = "Specifies the number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days."
}

# Secrets
variable "secrets" {
  type        = any
  default     = []
  sensitive   = true
  description = "List of secrets to keep in AWS Secrets Manager"
}

variable "unmanaged" {
  type        = bool
  default     = false
  description = "Terraform must ignore secrets lifecycle. Using this option you can initialize the secrets and rotate them outside Terraform, thus, avoiding other users to change or rotate the secrets by subsequent runs of Terraform"
}

variable "enable_rotation" {
  type        = bool
  default     = false
  description = "Determines whether secret rotation is enabled"
}

variable "rotation_lambda_arn" {
  type        = string
  default     = ""
  description = "Specifies the ARN of the Lambda function that can rotate the secret"
}

variable "rotation_rules" {
  type        = map(any)
  default     = {}
  description = "A structure that defines the rotation configuration for this secret"
}

variable "replica" {
  type        = map(any)
  default     = {}
  description = "Configuration block to support secret replication"
}

variable "create_unmanaged_version" {
  type        = bool
  default     = false
  description = "Whether to create secret versions for unmanaged secrets (existing secrets)"
}