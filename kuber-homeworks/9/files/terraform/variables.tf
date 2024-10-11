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
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}


###vm-count vars
variable "family" {
  type        = string
  default     = "ubuntu-2404-lts-oslogin"
  description = "OS"
}

variable "kube" {
  type = number
  default = 1
  description = "Number of VMs"
}

variable "platform" {
  type        = string
  default     = "standard-v1"
  description = "Platform for physical processor"
}

variable "infrastructure" {
  type = map(number)
  default = {
    cores         = 2,
    memory        = 2,
    core_fraction = 5
  }
  description = "VM specifications"
}

variable "preemptible" {
  type        = bool
  default     = true
  description = "VM scheduling policy"
}

variable "nat" {
  type        = bool
  default     = true
  description = "External ip"
}

#variable "metadata" {
#  type    = object({ serial-port-enable=number, ssh-keys=string })
#  default = {
#    serial-port-enable = 1
#    ssh-keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMYRgvwtM56cuoHAFEMSrQSBbEUaixEMjMYTWXNm63hYwqhQRgEVywAeDgChKNly/mXj7USgjj4p65ile9oVaQYCd+bOgTSwQXPFUmv980ak83WdOdpN7ZbRY246vc4P08mfweDTDNkb2VzDehTLjzSnhw9HogrGkGjIsW6Yc1CBdVTZQnsmR3gppL4h/wRZb5/T93NplFRt3ArLopalNJ5yTvyVElTMlIMVxZZlCtcJOwNlDUcEYlbE1wuEDZiluowNkP9ifnvOxgGPCzzPfT7JmBns4sbDUuaFyr6FQfUmK9l7T5qJF0hEds0CTt3mRjIDgulfHxiPyfSNrPB1EX+UJyMbsBbhyl0xwDE7Ikkolof+GNFW4V9bUdBSzosvADVeFLe/OzAkHqRIoBW5qRCaPCWTLaoXDCbYB4v9lhEiqGyBfYdvVjU1LeecGqSB+AkgJH1KXJKwcaFBN4KuKxuSfHqivZc6G69N1bC8oYvT8zjIRB0idhZ3CL6cMMVic= vagrant@server"
#  }
#}



###ansible_vars
#variable "web_provision" {
#  type    = bool
#  default = true
#  description="ansible provision switch variable"
#}
