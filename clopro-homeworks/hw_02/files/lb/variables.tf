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

variable "subnet_name" {
  type        = string
  default     = "my_subnet"
  description = "Name of public subnet"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

###vm vars
variable "vm" {
  type = map(object({
                        vm_image    = string,
                        platform    = string,
                        cores       = number,
                        memory      = number,
                        core_fr     = number,
                        nat         = bool }))
  default = {
      lamp = {
        vm_image    = "fd827b91d99psvq5fjit"
        platform    = "standard-v1"
        cores       = 2
        memory      = 2
        core_fr     = 5
        nat         = true
      }
  }
  
}
