# Сеть из ДЗ 1 (1sthw) — перед apply нужно: cd ../1sthw/yandex && terraform apply

data "yandex_vpc_network" "main" {
  name = var.network_name
}

data "yandex_vpc_subnet" "public" {
  name = var.public_subnet_name
}
