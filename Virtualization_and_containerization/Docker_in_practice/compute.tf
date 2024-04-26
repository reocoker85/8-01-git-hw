data "yandex_compute_image" "ubuntu_image" {
  family = "ubuntu-2004-lts"
}

     
resource "yandex_compute_instance" "vm" {
  name        = "testmachine"
  hostname    = "testmachine" 
  platform_id = "standard-v3" 
  zone        = "ru-central1-a"

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
      image_id = data.yandex_compute_image.ubuntu_image.id
      size     = 10 
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-a.id
    nat                = true
  }
  
  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  connection {
    type = "ssh"
    user = "user"
    private_key = file("./id_rsa")
    host = yandex_compute_instance.vm.network_interface.0.nat_ip_address
  }

  provisioner "file" {
    source = "./bash.sh"
    destination = "/home/user/bash.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/bash.sh",
          "cd ~",
          "~/bash.sh"
    ]
  }
}

resource "yandex_vpc_network" "devops-network" {
  name = "devops-network"
}

resource "yandex_vpc_subnet" "subnet-a" {
  name           = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.devops-network.id
  v4_cidr_blocks = ["192.168.10.0/28"]
}


output "instance_ip_addr" {
  value = yandex_compute_instance.vm.network_interface.0.nat_ip_address
}
