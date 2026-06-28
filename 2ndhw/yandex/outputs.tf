output "bucket_name" {
  description = "Object Storage bucket name"
  value       = yandex_storage_bucket.images.bucket
}

output "image_public_url" {
  description = "Public URL of the image in Object Storage"
  value       = local.image_url
}

output "nlb_public_ip" {
  description = "Public IP of the Network Load Balancer"
  value       = local.nlb_public_ip
}

output "instance_group_id" {
  description = "Instance group ID"
  value       = yandex_compute_instance_group.lamp.id
}

output "target_group_id" {
  description = "NLB target group ID"
  value       = yandex_compute_instance_group.lamp.load_balancer[0].target_group_id
}

output "check_website" {
  description = "Open this URL in browser to verify the site"
  value       = "http://${local.nlb_public_ip}/"
}

output "check_image" {
  description = "Direct link to the image in Object Storage"
  value       = local.image_url
}
