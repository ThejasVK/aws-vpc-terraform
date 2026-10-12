output "vpc_id" {
  description = "ID of the VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_public_ips" {
  description = "Egress IPs for private subnets."
  value       = module.vpc.nat_gateway_public_ips
}

output "flow_log_group" {
  description = "CloudWatch log group with VPC flow logs."
  value       = module.vpc.flow_log_group
}

output "bastion_instance_id" {
  description = "Bastion instance ID. Connect with: aws ssm start-session --target <id>"
  value       = try(module.compute[0].bastion_instance_id, null)
}

output "app_instance_id" {
  description = "Private app instance ID. Connect with: aws ssm start-session --target <id>"
  value       = try(module.compute[0].app_instance_id, null)
}

output "app_private_ip" {
  description = "Private IP of the app instance (ping it from the bastion)."
  value       = try(module.compute[0].app_private_ip, null)
}
