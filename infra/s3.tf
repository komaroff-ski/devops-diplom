terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "ksg-tfstate"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = "YCAJEB7GxVdKNWGep9NUsvHY4"
    secret_key = "YCPjZRV0YViMTaJWI_atk90eLaNubSMdqvkPm7uA"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}