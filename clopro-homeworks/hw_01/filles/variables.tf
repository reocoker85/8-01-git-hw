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

variable "default_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "subnet_public_name" {
  type        = string
  default     = "public"
  description = "Name of public subnet"
}

variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "subnet_private_name" {
  type        = string
  default     = "private"
  description = "Name of privet subnet"
}

variable "private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}
variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

###nat-instance vars
variable "nat_instance" {
  type = map(object({
    nat_image       = string
    name            = string
    platform        = string
    image_id        = string
    cores           = number
    memory          = number
    core_fraction   = number
    preemptible     = bool
    nat             = bool
    nat_internal_ip = string
  }))
  default = {
    nat_vm = {
      nat_image     = "fd80mrhj8fl2oe87o4e1"
      name          = "nat-instance"
      platform      = "standard-v2"
      image_id      = "fd80mrhj8fl2oe87o4e1"
      cores         = 2
      memory        = 2
      core_fraction = 5
      preemptible   = true
      nat           = true
      nat_internal_ip = "192.168.10.254"
    }
  }
}

###vm vars
variable "vm" {
  type = map(object({
    vm_image    = string
    name        = string
    platform_id = string
    cores       = number
    memory      = number
    core_fraction   = number
    preemptible     = bool
    nat_enable  = bool
  }))
  default = {
    public_vm = {
      vm_image    = "fd885unga0d8prsl1acs"
      name        = "public-vm"
      platform_id = "standard-v2"
      cores       = 2
      memory      = 2
      core_fraction = 5
      preemptible   = true
      nat_enable  = true
    }
    private_vm = {
      vm_image    = "fd885unga0d8prsl1acs"
      name        = "private-vm"
      platform_id = "standard-v2"
      cores       = 2
      memory      = 2
      core_fraction = 5
      preemptible   = true
      nat_enable  = false
    }
  }
}
