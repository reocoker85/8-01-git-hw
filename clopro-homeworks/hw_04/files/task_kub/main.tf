resource "yandex_kubernetes_cluster" "k8s-regional" {
  name       = "k8s-regional"
  network_id = yandex_vpc_network.my_vpc.id
  master {
    dynamic "master_location" {
      for_each = toset(var.zones_kub)
      content {
        zone      = master_location.value
        subnet_id = element(yandex_vpc_subnet.public[*].id, index(var.zones_kub, master_location.value))
      }
    }
    public_ip = true
    security_group_ids = [yandex_vpc_security_group.regional-k8s-sg.id]
  }
  service_account_id      = yandex_iam_service_account.my-regional-account.id
  node_service_account_id = yandex_iam_service_account.my-regional-account.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_member.encrypterDecrypter
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }
}

resource "yandex_kubernetes_node_group" "mygroup" {
  cluster_id  = yandex_kubernetes_cluster.k8s-regional.id
  name        = var.node_group.mygroup.name
  description = "autoscale node group"
  version     = var.node_group.mygroup.version
  depends_on = [
    yandex_kubernetes_cluster.k8s-regional
  ]

  instance_template {
    platform_id = var.node_group.mygroup.inst_platform

    network_interface {
      nat        = var.node_group.mygroup.nat
      subnet_ids = [yandex_vpc_subnet.public[1].id]
    }

    resources {
      memory = var.node_group.mygroup.memory
      core_fraction = var.node_group.mygroup.core_fr
      cores  = var.node_group.mygroup.cores
    }

    boot_disk {
      type = var.node_group.mygroup.disk_type
      size = var.node_group.mygroup.disk_size
    }

    scheduling_policy {
      preemptible = var.node_group.mygroup.preemptible
    }

    container_runtime {
      type = var.node_group.mygroup.cont_run_type
    }
  }

  scale_policy {
    auto_scale {
      min     = var.node_group.mygroup.auto_scale_min
      max     = var.node_group.mygroup.auto_scale_max
      initial = var.node_group.mygroup.auto_scale_ini
    }
  }

  allocation_policy {
    location {
      zone = element(var.zones_kub, 1)
    }
  }
}

resource "yandex_iam_service_account" "my-regional-account" {
  name        = "regional-k8s-account"
  description = "K8S regional service account"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  # Сервисному аккаунту назначается роль "k8s.clusters.agent".
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.my-regional-account.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  # Сервисному аккаунту назначается роль "vpc.publicAdmin".
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.my-regional-account.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.my-regional-account.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "encrypterDecrypter" {
  # Сервисному аккаунту назначается роль "kms.keys.encrypterDecrypter".
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.my-regional-account.id}"
}

resource "yandex_kms_symmetric_key" "kms-key" {
  # Ключ Yandex Key Management Service для шифрования важной информации, такой как пароли, OAuth-токены и SSH-ключи.
  name              = var.kms_key.key.name
  default_algorithm = var.kms_key.key.default_algorithm
  rotation_period   = var.kms_key.key.rotation_period
}

resource "yandex_vpc_security_group" "regional-k8s-sg" {
  name        = "regional-k8s-sg"
  description = "Правила группы обеспечивают базовую работоспособность кластера Managed Service for Kubernetes. Примените ее к кластеру и группам узлов."
  network_id  = yandex_vpc_network.my_vpc.id
  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      protocol          = lookup(ingress.value, "protocol", null)
      description       = lookup(ingress.value, "description", null)
      port              = lookup(ingress.value, "port", null)
      from_port         = lookup(ingress.value, "from_port", null)
      to_port           = lookup(ingress.value, "to_port", null)
      v4_cidr_blocks    = lookup(ingress.value, "v4_cidr_blocks", null)
      predefined_target = lookup(ingress.value, "predefined_target", null)
    }
  }
  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      protocol       = lookup(egress.value, "protocol", null)
      description    = lookup(egress.value, "description", null)
      port           = lookup(egress.value, "port", null)
      from_port      = lookup(egress.value, "from_port", null)
      to_port        = lookup(egress.value, "to_port", null)
      v4_cidr_blocks = lookup(egress.value, "v4_cidr_blocks", null)
    }
  }
}
