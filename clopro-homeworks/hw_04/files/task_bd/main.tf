resource "yandex_mdb_mysql_cluster" "cluster_mysql" {
  name                = var.cluster.mysql.name
  environment         = var.cluster.mysql.environment
  network_id          = yandex_vpc_network.my_vpc.id
  version             = var.cluster.mysql.version
  deletion_protection = var.cluster.mysql.del_protec

  resources {
    resource_preset_id = var.cluster.mysql.resource_id
    disk_type_id       = var.cluster.mysql.disk_type_id
    disk_size          = var.cluster.mysql.disk_size
  }

  host {
    zone             = var.default_zone
    subnet_id        = yandex_vpc_subnet.my_subnet.id
    assign_public_ip = var.cluster.mysql.public_ip
#    priority         = <приоритет_при_выборе_хоста-мастера>
#    backup_priority  = <приоритет_для_резервного_копирования>
  }
}

resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.cluster_mysql.id
  name       = var.bd.netology.name
}

resource "yandex_mdb_mysql_user" "reocoker" {
  cluster_id = yandex_mdb_mysql_cluster.cluster_mysql.id
  name       = var.bd.netology.user_name
  password   = var.bd.netology.password
  permission {
    database_name = var.bd.netology.name
    roles         = ["ALL"]
  }
}

resource "yandex_vpc_network" "my_vpc" { name = var.vpc_name }

resource "yandex_vpc_subnet" "my_subnet" {
  name           = var.subnet_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.my_vpc.id
  v4_cidr_blocks = var.default_cidr
}

