output "nat_instance_public_ip" {
  description = "Public IP of NAT instance"
  value       = yandex_compute_instance.nat.network_interface[0].nat_ip_address
}

output "nat_instance_internal_ip" {
  description = "Internal IP of NAT instance"
  value       = yandex_compute_instance.nat.network_interface[0].ip_address
}

output "public_vm_public_ip" {
  description = "Public IP of public VM (jump host)"
  value       = yandex_compute_instance.public.network_interface[0].nat_ip_address
}

output "public_vm_internal_ip" {
  description = "Internal IP of public VM"
  value       = yandex_compute_instance.public.network_interface[0].ip_address
}

output "private_vm_internal_ip" {
  description = "Internal IP of private VM"
  value       = yandex_compute_instance.private.network_interface[0].ip_address
}

output "ssh_public_vm" {
  description = "SSH command to connect to public VM"
  value       = "ssh ${var.vm_user}@${yandex_compute_instance.public.network_interface[0].nat_ip_address}"
}

output "ssh_private_vm_via_public" {
  description = "SSH command to connect to private VM via public VM jump host"
  value       = "ssh -J ${var.vm_user}@${yandex_compute_instance.public.network_interface[0].nat_ip_address} ${var.vm_user}@${yandex_compute_instance.private.network_interface[0].ip_address}"
}
