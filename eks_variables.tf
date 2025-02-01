variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
  default = ["subnet-0b3e21dff62bc9fa2", "subnet-0c1a4e750736c39e7"]
}
