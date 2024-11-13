resource "yandex_iam_service_account" "reocoker" {
  name        = "reocoker"
  description = "Сервисный аккаунт для управления группой ВМ."
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id  = var.folder_id
  role       = "editor"
  member     = "serviceAccount:${yandex_iam_service_account.reocoker.id}"
  depends_on = [
    yandex_iam_service_account.reocoker,
  ]
}

resource "yandex_compute_instance_group" "ig-1" {
  name                = "fixed-ig"
  folder_id           = var.folder_id
  service_account_id  = "${yandex_iam_service_account.reocoker.id}"
  deletion_protection = false
  depends_on          = [yandex_resourcemanager_folder_iam_member.editor]
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
      core_fraction = 5
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      }
    }

    service_account_id = "${yandex_iam_service_account.reocoker.id}"

    network_interface {
      network_id         = "${yandex_vpc_network.my_vpc.id}"
      subnet_ids         = ["${yandex_vpc_subnet.my_subnet.id}"]
      nat                = true
    }

    metadata = {
      user-data          = data.template_file.cloudinit.rendered
      serial-port-enable = 1
    }
  }
  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }
  
  health_check {
    interval = 5
    timeout = 2
    unhealthy_threshold = 2
    healthy_threshold = 2

    tcp_options {
      port = 80
    }
  }
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yaml")

  vars = {
    ssh_public_key     = file("~/.ssh/id_rsa.pub")
  }

}

resource "yandex_vpc_network" "my_vpc" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "my_subnet" {
  name           = var.subnet_name
  zone           = var.default_zone
  network_id     = "${yandex_vpc_network.my_vpc.id}"
  v4_cidr_blocks = var.default_cidr
}

