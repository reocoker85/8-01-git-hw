output "internal_ip_address_vm" {
  value = {
    for vm in yandex_compute_instance.vm:
    vm.name => vm.network_interface.0.ip_address
  }
}

output "external_ip_address_vm" {
  value = {
    for vm in yandex_compute_instance.vm:
    vm.name => vm.network_interface.0.nat_ip_address
  }
}
