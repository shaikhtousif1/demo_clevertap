variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# EKS variables
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.27"
}

variable "on_demand_instance_types" {
  description = "List of instance types for on-demand node group"
  type        = list(string)
  default     = ["m5.large"]
}

variable "on_demand_desired_size" {
  description = "Desired size for on-demand node group"
  type        = number
  default     = 2
}

variable "on_demand_min_size" {
  description = "Minimum size for on-demand node group"
  type        = number
  default     = 1
}

variable "on_demand_max_size" {
  description = "Maximum size for on-demand node group"
  type        = number
  default     = 4
}

variable "spot_instance_types" {
  description = "List of instance types for spot node group"
  type        = list(string)
  default     = ["m5.large", "m4.large", "t3.large"]
}

variable "spot_desired_size" {
  description = "Desired size for spot node group"
  type        = number
  default     = 3
}

variable "spot_min_size" {
  description = "Minimum size for spot node group"
  type        = number
  default     = 1
}

variable "spot_max_size" {
  description = "Maximum size for spot node group"
  type        = number
  default     = 10
}

# RDS variables
variable "db_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "14.6"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Maximum allocated storage in GB for autoscaling"
  type        = number
  default     = 100
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "customerengagement"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot when destroying the resource"
  type        = bool
  default     = false
}

# ALB variables
variable "health_check_path" {
  description = "Health check path for the default target group"
  type        = string
  default     = "/health"
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = true
}

# Redis variables
variable "redis_node_type" {
  description = "ElastiCache Redis node type"
  type        = string
  default     = "cache.t3.medium"
}