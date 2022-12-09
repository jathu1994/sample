# Add variables
variable "default_tags" {
  default = {
    "Owner" = "Jatharthan"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Add variables
variable "prefix" {
  default     = "week4"
  type        = string
  description = "Name prefix"
}

# VPC cidr block
variable "vpc_cidr" {
  default     = "10.20.0.0/16"
  type        = string
  description = "custom vpc cidr"
}

# deployed environment block 
variable "env" {
  default     = "test"
  type        = string
  description = "Deployment Environment"
}

# Provision public subnets in custom VPC
variable "private_cidr_blocks" {
  default     = ["10.20.0.0/24", "10.20.1.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}
