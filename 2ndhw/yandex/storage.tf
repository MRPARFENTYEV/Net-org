# --- Object Storage ---
# Бакет создаётся через IAM-токен пользователя (YC_TOKEN).
# Нужна роль storage.editor или storage.admin на каталог — см. README.

resource "yandex_storage_bucket" "images" {
  bucket    = var.bucket_name
  folder_id = var.folder_id
  max_size  = 1073741824 # 1 GB

  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }
}

resource "yandex_storage_object" "picture" {
  bucket       = yandex_storage_bucket.images.bucket
  key          = var.image_object_key
  source       = "${path.module}/assets/picture.png"
  source_hash  = filemd5("${path.module}/assets/picture.png")
  content_type = "image/png"
}
