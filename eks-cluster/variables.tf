variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH key for EC2 instances"
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances in the node group"
  type        = number
}

variable "max_capacity" {
  description = "Maximum number of EC2 instances in the node group"
  type        = number
}

variable "min_capacity" {
  description = "Minimum number of EC2 instances in the node group"
  type        = number
}
