variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

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