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

variable "my_ip" {
  description = "Your public IP address for SSH access (format: x.x.x.x/32)"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID used for unique bucket naming"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public SSH key for EC2 access"
  type        = string
  default     = "~/.ssh/quantstream.pub"
}