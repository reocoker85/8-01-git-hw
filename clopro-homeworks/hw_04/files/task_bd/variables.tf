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

variable "subnet_name" {
  type        = string
  default     = "private"
  description = "Name of public subnet"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["192.168.0.0/16"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "zones" {
  type    = list(string)
  default = ["ru-central1-a", "ru-central1-b"]
}

variable "vpc_name" {
  type        = string
  default     = "my_vpc"
  description = "VPC network&subnet name"
}

###cluster vars
variable "cluster" {
  type = object({
    mysql = object({
      name         = string
      environment  = string
      version      = string
      del_protec   = bool
      resource_id  = string
      disk_type_id = string
      disk_size    = number
      public_ip    = bool
      type         = string
      back_h       = number
      back_m       = number
    })
  })
  default = {
    mysql = {
      name         = "cluster_mysql"
      environment  = "PRESTABLE"
      version      = "8.0"
      del_protec   = false
      resource_id  = "b1.medium"
      disk_type_id = "network-hdd"
      disk_size    = 20
      public_ip    = false
      type         = "ANYTIME"
      back_h       = 23
      back_m       = 59
    }
  }
}

###bd vars
variable "bd" {
  type = object({
    netology = object({
      name      = string
      user_name = string
      password  = string
      roles     = string
    })
  })
  default = {
    netology = {
      name      = "netology_db"
      user_name = "reo"
      password  = "qwer1234"
      roles     = "ALL"
    }
  }
}


