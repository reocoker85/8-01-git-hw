resource "yandex_compute_instance" "instance" {

  name        = var.instance.vm.name
  hostname    = var.instance.vm.name
  platform_id = var.instance.vm.platform
  zone = element(var.zones_kub, 1)

  resources {
    cores         = var.instance.vm.cores
    memory        = var.instance.vm.memory
    core_fraction = var.instance.vm.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.instance.vm.image_id
    }                                                                        
  }
                                                                                                                   
  scheduling_policy {
    preemptible = var.instance.vm.preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public[1].id
    nat                = var.instance.vm.nat
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered 
    serial-port-enable = 1
  }
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yaml")

  vars = {
    ssh_public_key     = file("~/.ssh/id_rsa.pub")
  }

}

output "external_ip_instance" {
  value = yandex_compute_instance.instance.network_interface[0].nat_ip_address
}
