#data "yandex_alb_target_group" "tg" {
#  name = yandex_compute_instance_group.ig-1.application_load_balancer.0.target_group_id
#}


resource "yandex_alb_backend_group" "backend-group" {
  name                     = "test-bg"

  http_backend {
    name                   = "test-backend"
    weight                 = 1
    port                   = 80
    target_group_ids       = [yandex_compute_instance_group.ig-1.application_load_balancer.0.target_group_id]
    load_balancing_config {
      panic_threshold      = 90
    }    
    healthcheck {
      timeout              = "30s"
      interval             = "10s"
      healthy_threshold    = 10
      unhealthy_threshold  = 15 
      http_healthcheck {
        path               = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "tf-router" {
  name          = "test-router"
  labels        = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}

resource "yandex_alb_virtual_host" "my-virtual-host" {
  name                    = "test-vh"
  http_router_id          = yandex_alb_http_router.tf-router.id
  route {
    name                  = "test-route"
    http_route {
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.backend-group.id
        timeout           = "60s"
      }
    }
  }
} 


resource "yandex_alb_load_balancer" "test-balancer" {
  name        = "test-balancer"
  network_id  = yandex_vpc_network.my_vpc.id

  allocation_policy {
    location {
      zone_id   = var.default_zone
      subnet_id = yandex_vpc_subnet.my_subnet.id 
    }
  }
   
  listener {
    name = "test-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.tf-router.id
      }
    }
  }
}
