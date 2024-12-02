resource "yandex_vpc_network" "my_vpc" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  count          = length(var.zones_kub)
  name           = "${var.public_subnet_name}-${var.zones_kub[count.index]}"
  v4_cidr_blocks = [cidrsubnet(var.public_cidr[0], 2, count.index)]
  zone           = var.zones_kub[count.index]
  network_id     = yandex_vpc_network.my_vpc.id
}

resource "yandex_vpc_subnet" "private" {
  count          = length(var.zones_bd)
  name           = "${var.private_subnet_name}-${var.zones_bd[count.index]}"
  v4_cidr_blocks = [cidrsubnet(var.private_cidr[0], 2, count.index)]
  zone           = var.zones_bd[count.index]
  network_id     = yandex_vpc_network.my_vpc.id
}
