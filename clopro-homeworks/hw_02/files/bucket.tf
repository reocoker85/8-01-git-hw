resource "random_string" "unique_id" {
  length  = 8
  upper   = false
  lower   = true
  numeric = true
  special = false
}

module "s3" {
  source = "./modules/s3"
  folder_id = var.folder_id
  bucket = "simple-bucket-${random_string.unique_id.result}"
}

resource "yandex_storage_object" "test-object" {
  access_key = module.s3.access_key
  secret_key = module.s3.secret_key
  bucket     = "simple-bucket-${random_string.unique_id.result}"
  key        = "devops.jpg"
  source     = "./devops.jpg"
  depends_on = [module.s3.storage]
}

output "access_key"{
    value = module.s3.access_key
}

output "secret_key"{
    value = nonsensitive(module.s3.secret_key)
}
