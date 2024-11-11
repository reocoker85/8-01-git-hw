 locals {
          subnet1 = yandex_vpc_subnet.public.id
          subnet2 = yandex_vpc_subnet.private.id
        }

resource "yandex_compute_instance" "vm" {
  for_each = {
    for index, vm in var.each_vm:
    vm.vm_name => vm
  }
  name        = each.value.vm_name
  hostname    = each.value.hostname
  platform_id = each.value.platform

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fr
  }

  boot_disk {
    initialize_params {
      image_id = each.value.vm_image
      size     = each.value.disk_size
    }
  }

  scheduling_policy {
    preemptible = each.value.preemptible
  }

  network_interface {
    subnet_id          = "${each.value.subnet}" == "subnet1" ? "${local.subnet1}" : "${each.value.subnet}" == "subnet2" ? "${local.subnet2}" :""
    nat                = each.value.nat
  }
  
  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}

