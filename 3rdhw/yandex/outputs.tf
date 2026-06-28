output "kms_key_id" {
  description = "KMS symmetric key ID"
  value       = yandex_kms_symmetric_key.bucket.id
}

output "kms_key_name" {
  description = "KMS symmetric key name"
  value       = yandex_kms_symmetric_key.bucket.name
}

output "bucket_name" {
  description = "Encrypted bucket name"
  value       = yandex_storage_bucket.encrypted.bucket
}

output "verify_encryption_console" {
  description = "Check encryption in console"
  value       = "Object Storage → ${yandex_storage_bucket.encrypted.bucket} → Безопасность → Шифрование"
}
