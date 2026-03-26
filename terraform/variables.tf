variable "aws_region" {
    description = "AWS region for all resources"
    type = string
    default = "us-east-1"
}

variable "project_name" {
  description = "Project name used for tagging and naming resources"
  type        = string
  default     = "quantstream"
}

variable "db_password" {
  description = "Password for the RDS Postgres instance"
  type        = string
  sensitive   = true
}