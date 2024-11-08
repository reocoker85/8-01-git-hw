resource "yandex_compute_instance" "nat-instance" {

  name        = var.nat_instance.nat_vm.name
  hostname    = var.nat_instance.nat_vm.name
  platform_id = var.nat_instance.nat_vm.platform

  resources {
    cores         = var.nat_instance.nat_vm.cores
    memory        = var.nat_instance.nat_vm.memory
    core_fraction = var.nat_instance.nat_vm.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_instance.nat_vm.nat_image
    }                                                                        
  }
                                                                                                                   
  scheduling_policy {
    preemptible = var.nat_instance.nat_vm.preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    ip_address         = var.nat_instance.nat_vm.nat_internal_ip
    nat                = var.nat_instance.nat_vm.nat
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
