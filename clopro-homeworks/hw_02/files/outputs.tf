output "access_key"{
    value = yandex_iam_service_account_static_access_key.sa-static-key.access_key
}

output "secret_key"{
    value = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
}

output "storage"{
    value = yandex_storage_bucket.test
}
