resource "yandex_mdb_mysql_cluster" "cluster_mysql" {
  depends_on          = [yandex_vpc_network.my_vpc]
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

  dynamic "host" {
    for_each = toset(var.zones)
    content {
      zone             = host.value
      subnet_id        = element(yandex_vpc_subnet.private[*].id, index(var.zones, host.value))
      assign_public_ip = var.cluster.mysql.public_ip
    }
  }

  maintenance_window {
    type = var.cluster.mysql.type
  }

  backup_window_start {
    hours   = var.cluster.mysql.back_h
    minutes = var.cluster.mysql.back_m
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
    roles         = [var.bd.netology.roles]
  }
}

resource "yandex_vpc_network" "my_vpc" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "private" {
  count          = length(var.zones)
  name           = "${var.subnet_name}-${var.zones[count.index]}"
  v4_cidr_blocks = [cidrsubnet(var.default_cidr[0], 2, count.index)]
  zone           = var.zones[count.index]
  network_id     = yandex_vpc_network.my_vpc.id
}

