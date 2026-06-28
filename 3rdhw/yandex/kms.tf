resource "yandex_kms_symmetric_key" "bucket" {
  name              = var.kms_key_name
  description       = "KMS key for Object Storage bucket encryption (HW3)"
  default_algorithm = "AES_256"
  rotation_period   = "8760h"
}

resource "yandex_iam_service_account" "storage" {
  name        = "hw3-storage-sa"
  description = "Service account for bucket encryption operations"
}

resource "yandex_resourcemanager_folder_iam_member" "storage_admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.storage.id}"
}

resource "yandex_iam_service_account_static_access_key" "storage_key" {
  service_account_id = yandex_iam_service_account.storage.id
  description        = "Static key for Object Storage API"
}

resource "yandex_kms_symmetric_key_iam_member" "storage_sa_encrypter" {
  symmetric_key_id = yandex_kms_symmetric_key.bucket.id
  role             = "kms.keys.encrypterDecrypter"
  member           = "serviceAccount:${yandex_iam_service_account.storage.id}"
}
