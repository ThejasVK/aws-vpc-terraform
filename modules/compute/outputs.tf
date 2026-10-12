output "bastion_instance_id" {
  description = "Instance ID of the bastion (use with SSM Session Manager)."
  value       = aws_instance.bastion.id
}

output "bastion_public_ip" {
  description = "Public IP of the bastion."
  value       = aws_instance.bastion.public_ip
}

output "app_instance_id" {
  description = "Instance ID of the private app instance."
  value       = aws_instance.app.id
}

output "app_private_ip" {
  description = "Private IP of the app instance."
  value       = aws_instance.app.private_ip
}
