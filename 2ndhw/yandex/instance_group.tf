# --- Instance Group + Network Load Balancer ---

resource "yandex_iam_service_account" "ig" {
  name        = "hw2-ig-sa"
  description = "Service account for instance group and NLB"
}

resource "yandex_resourcemanager_folder_iam_member" "ig_compute" {
  folder_id = var.folder_id
  role      = "compute.editor"
  member    = "serviceAccount:${yandex_iam_service_account.ig.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "ig_nlb" {
  folder_id = var.folder_id
  role      = "load-balancer.editor"
  member    = "serviceAccount:${yandex_iam_service_account.ig.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "ig_vpc" {
  folder_id = var.folder_id
  role      = "vpc.user"
  member    = "serviceAccount:${yandex_iam_service_account.ig.id}"
}

resource "yandex_vpc_security_group" "lamp" {
  name       = "hw2-lamp-sg"
  network_id = data.yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "ICMP"
    description    = "icmp"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_instance_group" "lamp" {
  name               = "hw2-lamp-ig"
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.ig.id

  instance_template {
    platform_id = "standard-v3"

    resources {
      core_fraction = 20
      cores         = 2
      memory        = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.lamp_image_id
        size     = 10
        type     = "network-hdd"
      }
    }

    network_interface {
      network_id         = data.yandex_vpc_network.main.id
      subnet_ids         = [data.yandex_vpc_subnet.public.id]
      security_group_ids = [yandex_vpc_security_group.lamp.id]
    }

    metadata = {
      user-data = templatefile("${path.module}/templates/cloud-init.yaml.tpl", {
        image_url = local.image_url
      })
    }
  }

  scale_policy {
    fixed_scale {
      size = var.instance_group_size
    }
  }

  allocation_policy {
    zones = [var.zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  health_check {
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2

    http_options {
      port = 80
      path = "/index.html"
    }
  }

  load_balancer {
    target_group_name        = "hw2-lamp-tg"
    target_group_description = "Target group for LAMP instance group"
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.ig_compute,
    yandex_resourcemanager_folder_iam_member.ig_nlb,
    yandex_resourcemanager_folder_iam_member.ig_vpc,
    yandex_storage_object.picture,
  ]
}

resource "yandex_lb_network_load_balancer" "main" {
  name      = "hw2-nlb"
  folder_id = var.folder_id

  listener {
    name        = "http"
    port        = 80
    protocol    = "tcp"
    target_port = 80

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.lamp.load_balancer[0].target_group_id

    healthcheck {
      name                = "http"
      interval            = 10
      timeout             = 5
      unhealthy_threshold = 3
      healthy_threshold   = 2

      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }

  depends_on = [yandex_compute_instance_group.lamp]
}
