variable "folder_id" {
  description = "Yandex Cloud folder ID"
  type        = string
}

variable "zone" {
  description = "Availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "bucket_name" {
  description = "Globally unique Object Storage bucket name (e.g. moray-20260628)"
  type        = string
}

variable "image_object_key" {
  description = "Object key for the uploaded image"
  type        = string
  default     = "picture.png"
}

variable "network_name" {
  description = "VPC name from 1sthw"
  type        = string
  default     = "hw15-vpc"
}

variable "public_subnet_name" {
  description = "Public subnet name from 1sthw"
  type        = string
  default     = "public"
}

variable "lamp_image_id" {
  description = "LAMP image ID recommended by homework"
  type        = string
  default     = "fd827b91d99psvq5fjit"
}

variable "instance_group_size" {
  description = "Number of VMs in the instance group"
  type        = number
  default     = 3
}
