variable "name" {
  description = "Name prefix for every resource."
  type        = string
}

variable "vpc_id" {
  description = "VPC to place the security groups in."
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet for the bastion host."
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet for the app instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for both hosts."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name for SSH. Leave null to use SSM Session Manager only."
  type        = string
  default     = null
}

variable "ssh_allowed_cidrs" {
  description = "CIDRs allowed to SSH to the bastion, e.g. [\"203.0.113.10/32\"]. Empty = no SSH."
  type        = list(string)
  default     = []
}
