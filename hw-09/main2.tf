resource "yandex_iam_service_account" "ig-sa" {
  name        = "ig-sa"
  description = "service account to manage IG"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.yandex_folder_id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.ig-sa.id}"
}

resource "yandex_compute_instance_group" "ig-1" {
  name                = "fixed-ig-with-balancer"
  folder_id           = var.yandex_folder_id
  service_account_id  = "${yandex_iam_service_account.ig-sa.id}"
  deletion_protection = false
  instance_template {
    platform_id = "standard-v3"
    resources {
      memory = 2
      cores  = 2
      core_fraction = 20
    }

    scheduling_policy {
      preemptible = true
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd8g5aftj139tv8u2mo1"
        size = 8
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.network-1.id}"
      subnet_ids = ["${yandex_vpc_subnet.subnet-1.id}"]
      nat = true
    }

    metadata = {
      user-data = "${file("./meta.txt")}"
    }
  }
  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "load balancer target group"
  
  }

}

resource "yandex_lb_network_load_balancer" "lb-1" {
  name = "network-load-balancer-1"

  listener {
    name = "network-load-balancer-1-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.ig-1.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.network-1.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}
