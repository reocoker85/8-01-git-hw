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

variable "default_zone" {
  type    = string
  default = "ru-central1-a"
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

