resource "yandex_compute_instance" "vm" {
  count = 2
  name = "vm${count.index}"
  allow_stopping_for_update = true  

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }
  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd8g5aftj139tv8u2mo1"
      size = 8 
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  
  metadata = {
    user-data = "${file("./meta.txt")}"
  }

# Установка nginx

  connection {
    type = "ssh"
    user = "user"
    private_key = file("/home/reocoker/homework/netology-gitlab-deploy/id_rsa")
    host = self.network_interface[0].nat_ip_address
  }

  provisioner "file" {
    source = "/home/reocoker/homework/netology-gitlab-deploy/nginx.sh"
    destination = "/home/user/nginx.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/nginx.sh",
          "cd ~",
          "~/nginx.sh"
    ]
  }

}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Создание таргет-группы

resource "yandex_lb_target_group" "vm-machine" {
  name = "vm-machine-target-group"

  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address   = yandex_compute_instance.vm[0].network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address   = yandex_compute_instance.vm[1].network_interface.0.ip_address
  }
}

# Создание балансировщика

resource "yandex_lb_network_load_balancer" "reo-load-balancer" {
  name = "reo-load-balancer"

  listener {
    name = "listener-vm-machine"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.vm-machine.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}
