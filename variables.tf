variable "project" {
  description = "Project name, used in resource names and tags."
  type        = string
  default     = "vpc-lab"
}

variable "environment" {
  description = "Environment name, e.g. dev or prod."
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones to use."
  type        = number
  default     = 2
}

variable "enable_nat_gateway" {
  description = "Create NAT gateway(s) for private-subnet internet access. NAT gateways cost money every hour."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "One shared NAT gateway (cheaper) instead of one per AZ (highly available)."
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Send VPC flow logs to CloudWatch Logs."
  type        = bool
  default     = true
}

variable "create_instances" {
  description = "Create the bastion and private app instance to test connectivity."
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair for SSH. Leave null to use SSM Session Manager only."
  type        = string
  default     = null
}

variable "ssh_allowed_cidrs" {
  description = "CIDRs allowed to SSH to the bastion, e.g. your IP as x.x.x.x/32."
  type        = list(string)
  default     = []
}
