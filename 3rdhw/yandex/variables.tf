variable "folder_id" {
  description = "Yandex Cloud folder ID"
  type        = string
}

variable "bucket_name" {
  description = "Object Storage bucket from 2ndhw to encrypt"
  type        = string
}

variable "kms_key_name" {
  description = "Name of the KMS symmetric key"
  type        = string
  default     = "hw3-bucket-key"
}
