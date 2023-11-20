resource "yandex_mdb_postgresql_cluster" "netology_db" {
  name                = "netology_db"
  environment         = "PRODUCTION"
  network_id          = yandex_vpc_network.mynet.id

  config {
    version = 15
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = "10"
    }
  }

  host {
    zone             = "ru-central1-a"
    name             = "master_host"
    subnet_id        = yandex_vpc_subnet.mysubnet-1.id
    assign_public_ip = true
  }
  
   host {
    name                    = "slave_host"
    zone                    = "ru-central1-b"
    subnet_id               = yandex_vpc_subnet.mysubnet-2.id
    replication_source_name = "master_host"
    assign_public_ip        = true
  }
}

resource "yandex_mdb_postgresql_database" "db" {
  cluster_id = yandex_mdb_postgresql_cluster.netology_db.id
  name       = "db"
  owner      = "reocoker"
}

resource "yandex_mdb_postgresql_user" "reocoker" {
  cluster_id = yandex_mdb_postgresql_cluster.netology_db.id
  name       = "reocoker"
  password   = "password"
}

resource "yandex_vpc_network" "mynet" {
  name = "mynet"
}

resource "yandex_vpc_subnet" "mysubnet-1" {
  name           = "mysubnet-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.mynet.id
  v4_cidr_blocks = ["10.1.0.0/24"]
}

resource "yandex_vpc_subnet" "mysubnet-2" {
  name           = "mysubnet-2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.mynet.id
  v4_cidr_blocks = ["10.2.0.0/24"]
}
