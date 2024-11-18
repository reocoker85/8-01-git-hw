resource "random_string" "unique_id" {
  length  = 8
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "yandex_iam_service_account" "sa" {
  name = "sa"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

#resource "yandex_resourcemanager_folder_iam_member" "encrypter" {
#  folder_id = var.folder_id
#  role      = "kms.keys.encrypterDecrypter"
#  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
#}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

#resource "yandex_kms_symmetric_key" "key-a" {
#  name              = "example-symetric-key"
#  description       = "description for key"
#  default_algorithm = "AES_128"
#  rotation_period   = "168h" 
#}

#resource "yandex_cm_certificate" "example" {
#  name    = "example"
#  domains = ["bucket-${random_string.unique_id.result}.website.yandexcloud.net"]
#
#  managed {
#    challenge_type = "HTTP"
#  }
#}

resource "yandex_storage_bucket" "test" {
  access_key            = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket                = "bucket-${random_string.unique_id.result}"
  max_size              = 1073741824
  acl                   = "public-read"
  website {
    index_document = "index.html"
    error_document = "error.html"
    routing_rules  = <<EOF
    [{
        "Condition": {
            "KeyPrefixEquals": "docs/"
        },
        "Redirect": {
            "ReplaceKeyPrefixWith": "documents/"
        }
    }]
    EOF
  }
#  https  {
#    certificate_id = yandex_cm_certificate.example.id
#  }
#  server_side_encryption_configuration {
#    rule {
#      apply_server_side_encryption_by_default {
#        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
#        sse_algorithm     = "aws:kms"
#      }
#    }
#  }
}

resource "yandex_storage_object" "test-object" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "bucket-${random_string.unique_id.result}"
  key        = "devops.jpg"
  source     = "./devops.jpg"
  acl        = "public-read"
  depends_on = [
                yandex_storage_bucket.test,
#                yandex_kms_symmetric_key.key-a
               ]
}


