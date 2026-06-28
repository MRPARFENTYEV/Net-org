locals {
  image_url = "https://storage.yandexcloud.net/${yandex_storage_bucket.images.bucket}/${var.image_object_key}"

  nlb_listener = one([for l in yandex_lb_network_load_balancer.main.listener : l if l.name == "http"])
  nlb_public_ip = one([
    for spec in local.nlb_listener.external_address_spec : spec.address
  ])
}
