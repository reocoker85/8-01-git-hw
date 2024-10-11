output "instance_ip" {
  value = [
    for compute in yandex_compute_instance.kube : [
      {
        name = compute.name
        ip_nat   = compute.network_interface.0.nat_ip_address
        ip       = compute.network_interface.0.ip_address
      }
    ]    
 ]
}
