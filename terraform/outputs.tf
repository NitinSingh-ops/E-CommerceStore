output "public_ip" {
  description = "Public IP address of the E-Commerce EC2 instance"
  value       = aws_instance.ecommerce.public_ip
}

output "public_dns" {
  description = "Public DNS name of the E-Commerce EC2 instance"
  value       = aws_instance.ecommerce.public_dns
}

output "frontend_url" {
  description = "Public URL of the E-Commerce frontend"
  value       = "http://${aws_instance.ecommerce.public_ip}"
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.ecommerce.id
}

output "vpc_id" {
  description = "E-Commerce VPC ID"
  value       = aws_vpc.ecommerce.id
}

output "subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "E-Commerce security group ID"
  value       = aws_security_group.ecommerce.id
}
