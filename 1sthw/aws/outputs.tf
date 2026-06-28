output "public_instance_public_ip" {
  description = "Public IP of public EC2 instance"
  value       = aws_instance.public.public_ip
}

output "public_instance_private_ip" {
  description = "Private IP of public EC2 instance"
  value       = aws_instance.public.private_ip
}

output "private_instance_private_ip" {
  description = "Private IP of private EC2 instance"
  value       = aws_instance.private.private_ip
}

output "ssh_public_instance" {
  description = "SSH command to connect to public instance"
  value       = "ssh -i ~/.ssh/id_rsa ${var.vm_user}@${aws_instance.public.public_ip}"
}

output "ssh_private_instance_via_public" {
  description = "SSH command to connect to private instance via public jump host"
  value       = "ssh -J ${var.vm_user}@${aws_instance.public.public_ip} ${var.vm_user}@${aws_instance.private.private_ip}"
}
