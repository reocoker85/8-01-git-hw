###cloud vars
variable "token" {
  type        = string
  sensitive   = true
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  sensitive   = true
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  sensitive   = true
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "public_subnet_name" {
  type        = string
  default     = "public"
  description = "Name of public subnet"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.5.0.0/16"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "zones" {
  type    = list(string)
  default = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
}

variable "vpc_name" {
  type        = string
  default     = "my_vpc"
  description = "VPC network&subnet name"
}

###security_group vars
variable "security_group_ingress" {
  type = list(object(
    {
      protocol          = string
      description       = string
      predefined_target = optional(string)
      v4_cidr_blocks    = optional(list(string))
      port              = optional(number)
      from_port         = optional(number)
      to_port           = optional(number)
    }
  ))
  default = []
}
variable "security_group_egress" {
  type = list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
    }
  ))
  default = []
}

###node_group vars
variable "node_group" {
  type = object({
    mygroup = object({
      name           = string
      version        = string
      inst_platform  = string
      nat            = bool
      memory         = number
      core_fr        = number
      cores          = number
      disk_size      = number
      disk_type      = string
      preemptible    = bool
      cont_run_type  = string
      auto_scale_min = number
      auto_scale_max = number
      auto_scale_ini = number
    })
  })
  default = {
    mygroup = {
      name           = "my-node-group"
      version        = "1.27"
      inst_platform  = "standard-v1"
      nat            = false
      memory         = 2
      core_fr        = 20
      cores          = 2
      disk_type      = "network-hdd"
      disk_size      = 30
      preemptible    = true
      cont_run_type  = "containerd"
      auto_scale_min = 3
      auto_scale_max = 6
      auto_scale_ini = 3
    }
  }
}

###kms-key vars
variable "kms_key" {
  type = object({
    key = object({
      name              = string
      default_algorithm = string
      rotation_period   = string
    })
  })
  default = {
    key = {
      name              = "kms-key"
      default_algorithm = "AES_128"
      rotation_period   = "8760h"
    }
  }
}
