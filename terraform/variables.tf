variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "mysql_tier" {
  description = "Cloud SQL machine tier; choose based on workload and budget"
  type        = string
  default     = "db-custom-2-7680"
}

variable "mysql_deletion_protection" {
  description = "Protect Cloud SQL from accidental deletion"
  type        = bool
  default     = true
}
