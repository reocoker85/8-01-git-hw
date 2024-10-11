data "yandex_compute_image" "ubuntu" {
  family = var.family
}

resource "yandex_compute_instance" "kube" {

  count       = var.kube

  name        = "kube-${count.index + 1}"
  hostname    = "kube-${count.index + 1}"
  platform_id = var.platform

  resources {
    cores         = var.infrastructure.cores
    memory        = var.infrastructure.memory
    core_fraction = var.infrastructure.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }                                                                        
  }
                                                                                                                   
  scheduling_policy {
    preemptible = var.preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.nat
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered 
    serial-port-enable = 1
  }
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yaml")

  vars = {
    ssh_public_key     = file("~/.ssh/id_ed25519.pub")
  }

}
