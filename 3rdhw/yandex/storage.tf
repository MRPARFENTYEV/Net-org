# Бакет создан в 2ndhw — перед первым apply выполните import (см. README).

resource "yandex_storage_bucket" "encrypted" {
  bucket     = var.bucket_name
  folder_id  = var.folder_id
  max_size   = 1073741824
  access_key = yandex_iam_service_account_static_access_key.storage_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.storage_key.secret_key

  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.storage_admin,
    yandex_kms_symmetric_key_iam_member.storage_sa_encrypter,
  ]
}
