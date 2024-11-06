resource "yandex_compute_instance" "nat-instance" {

  name        = var.nat_name
  hostname    = var.nat_name
  platform_id = var.platform

  resources {
    cores         = var.infrastructure.cores
    memory        = var.infrastructure.memory
    core_fraction = var.infrastructure.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_image
    }                                                                        
  }
                                                                                                                   
  scheduling_policy {
    preemptible = var.preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    ip_address         = var.nat_internal_ip
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
