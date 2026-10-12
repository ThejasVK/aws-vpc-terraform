variable "name" {
  description = "Name prefix for every resource."
  type        = string
}

variable "region" {
  description = "AWS region, used to build the S3 endpoint service name."
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC."
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "cidr_block must be a valid IPv4 CIDR, e.g. 10.0.0.0/16."
  }
}

variable "azs" {
  description = "Availability zones to spread subnets across (one public and one private subnet per AZ)."
  type        = list(string)

  validation {
    condition     = length(var.azs) >= 2 && length(var.azs) <= 6
    error_message = "Use between 2 and 6 availability zones."
  }
}

variable "subnet_newbits" {
  description = "Bits added to the VPC prefix for each subnet. 8 turns a /16 into /24 subnets."
  type        = number
  default     = 8
}

variable "enable_nat_gateway" {
  description = "Create NAT gateway(s) so private subnets can reach the internet."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Share one NAT gateway across all AZs (cheaper, not highly available)."
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Send VPC flow logs to CloudWatch Logs."
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "How long to keep flow logs."
  type        = number
  default     = 7
}
