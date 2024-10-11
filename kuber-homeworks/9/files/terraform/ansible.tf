data "template_file" "inventory" {
  template = "${file("inventory.tftpl")}"
  vars = {
         kubehost = "${yandex_compute_instance.kube[0].network_interface.0.nat_ip_address}"
         }
}

resource "null_resource" "update_inventory" {

    triggers = {
        template = "${data.template_file.inventory.rendered}"
    }

    provisioner "local-exec" {
        command = "echo '${data.template_file.inventory.rendered}' > /home/reo/netology/hw09/ansible/inventory.yaml"
    }
}
